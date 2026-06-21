import 'dart:convert';

import 'package:rps_duel/domain/achievement.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the unlocked achievement set with per-id timestamps.
///
/// Schema v2 stores `Map<AchievementId, DateTime?>` as a JSON object
/// where each value is an ISO-8601 string or `null` (for entries that
/// migrated from schema v1, which did not record when each one was
/// unlocked). Migration runs once on first `open()` after upgrade.
class AchievementStorage {
  AchievementStorage(this._prefs);

  static const String _v1Key = 'rps_duel.achievements.v1';
  static const String _v2Key = 'rps_duel.achievements.v2';

  final SharedPreferences _prefs;

  static Future<AchievementStorage> open() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = AchievementStorage(prefs);
    await storage._migrateIfNeeded();
    return storage;
  }

  Map<AchievementId, DateTime?> load() {
    final raw = _prefs.getString(_v2Key);
    if (raw == null) return <AchievementId, DateTime?>{};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return <AchievementId, DateTime?>{};
      final out = <AchievementId, DateTime?>{};
      decoded.forEach((key, value) {
        if (key is! String) return;
        AchievementId? id;
        try {
          id = AchievementId.values.byName(key);
        } catch (_) {
          // Unknown enum name — forward-compat / corrupt entry. Skip.
          return;
        }
        if (value == null) {
          out[id] = null;
        } else if (value is String) {
          out[id] = DateTime.tryParse(value);
        }
      });
      return out;
    } catch (_) {
      return <AchievementId, DateTime?>{};
    }
  }

  Future<void> save(Map<AchievementId, DateTime?> entries) async {
    final encoded = <String, String?>{
      for (final entry in entries.entries)
        entry.key.name: entry.value?.toIso8601String(),
    };
    await _prefs.setString(_v2Key, jsonEncode(encoded));
  }

  Future<void> _migrateIfNeeded() async {
    if (_prefs.containsKey(_v2Key)) return;
    final legacy = _prefs.getStringList(_v1Key);
    if (legacy == null) return;
    final migrated = <AchievementId, DateTime?>{};
    for (final name in legacy) {
      try {
        migrated[AchievementId.values.byName(name)] = null;
      } catch (_) {
        // Skip unknown legacy names.
      }
    }
    await save(migrated);
    await _prefs.remove(_v1Key);
  }
}
