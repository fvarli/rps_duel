import 'dart:convert';

import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists today's [DailyChallenge].
///
/// Schema v2 carries the `kind` + `target` fields introduced by the
/// daily-rotation feature. v1 records (no `kind`) migrate transparently
/// via [DailyChallenge.fromJson], which defaults the kind to
/// `winWithScissors` — the only challenge that ever shipped in v1.
class DailyChallengeStorage {
  DailyChallengeStorage(this._prefs);

  static const String _v1Key = 'rps_duel.daily_challenge.v1';
  static const String _v2Key = 'rps_duel.daily_challenge.v2';

  final SharedPreferences _prefs;

  static Future<DailyChallengeStorage> open() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = DailyChallengeStorage(prefs);
    await storage._migrateIfNeeded();
    return storage;
  }

  DailyChallenge? load() {
    final raw = _prefs.getString(_v2Key);
    if (raw == null) return null;
    try {
      return DailyChallenge.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(DailyChallenge challenge) async {
    await _prefs.setString(_v2Key, jsonEncode(challenge.toJson()));
  }

  Future<void> _migrateIfNeeded() async {
    if (_prefs.containsKey(_v2Key)) return;
    final legacy = _prefs.getString(_v1Key);
    if (legacy == null) return;
    try {
      // Round-trip through the model so the kind defaults are applied,
      // then persist under v2 and clear v1.
      final migrated = DailyChallenge.fromJson(
        jsonDecode(legacy) as Map<String, dynamic>,
      );
      await save(migrated);
    } catch (_) {
      // Corrupt v1 — drop it. Today's challenge will be freshly created.
    }
    await _prefs.remove(_v1Key);
  }
}
