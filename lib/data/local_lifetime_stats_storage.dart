import 'dart:convert';

import 'package:rps_duel/domain/lifetime_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the player's lifetime totals as a single JSON blob.
///
/// Schema v1 stores `{totalRounds, totalWins, totalTies}`. Missing fields
/// default to 0 on load — same defensive read pattern as the other
/// storage classes.
class LifetimeStatsStorage {
  LifetimeStatsStorage(this._prefs);

  static const String _key = 'rps_duel.lifetime_stats.v1';

  final SharedPreferences _prefs;

  static Future<LifetimeStatsStorage> open() async {
    final prefs = await SharedPreferences.getInstance();
    return LifetimeStatsStorage(prefs);
  }

  /// Returns null when nothing has ever been saved — distinguishes a
  /// genuine fresh install (no key) from a key with zeroed values.
  /// Callers use this to decide whether to backfill from the game state's
  /// aggregate counters on first run.
  LifetimeStats? load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return LifetimeStats.zero();
      return LifetimeStats.fromJson(Map<String, dynamic>.from(decoded));
    } catch (_) {
      return LifetimeStats.zero();
    }
  }

  Future<void> save(LifetimeStats stats) async {
    await _prefs.setString(_key, jsonEncode(stats.toJson()));
  }
}
