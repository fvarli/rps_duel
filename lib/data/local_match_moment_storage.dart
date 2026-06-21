import 'dart:convert';

import 'package:rps_duel/domain/match_moment.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the player's collected [MatchMomentId]s with per-moment
/// records (currently just the local-calendar date the moment occurred).
///
/// Schema v1 stores `Map<MatchMomentId, MatchMomentRecord>` as a JSON
/// object keyed by the enum name. Unknown / forward-compat keys are
/// silently skipped on load — same defensive read pattern as
/// [AchievementStorage].
class MatchMomentStorage {
  MatchMomentStorage(this._prefs);

  static const String _key = 'rps_duel.match_moments.v1';

  final SharedPreferences _prefs;

  static Future<MatchMomentStorage> open() async {
    final prefs = await SharedPreferences.getInstance();
    return MatchMomentStorage(prefs);
  }

  Map<MatchMomentId, MatchMomentRecord> load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return <MatchMomentId, MatchMomentRecord>{};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return <MatchMomentId, MatchMomentRecord>{};
      final out = <MatchMomentId, MatchMomentRecord>{};
      decoded.forEach((key, value) {
        if (key is! String) return;
        MatchMomentId? id;
        try {
          id = MatchMomentId.values.byName(key);
        } catch (_) {
          return;
        }
        if (value is Map) {
          try {
            out[id] = MatchMomentRecord.fromJson(
              Map<String, dynamic>.from(value),
            );
          } catch (_) {
            // Corrupt single-entry — skip.
          }
        }
      });
      return out;
    } catch (_) {
      return <MatchMomentId, MatchMomentRecord>{};
    }
  }

  Future<void> save(Map<MatchMomentId, MatchMomentRecord> entries) async {
    final encoded = <String, Map<String, Object?>>{
      for (final entry in entries.entries) entry.key.name: entry.value.toJson(),
    };
    await _prefs.setString(_key, jsonEncode(encoded));
  }
}
