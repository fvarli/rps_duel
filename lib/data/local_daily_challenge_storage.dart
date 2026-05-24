import 'dart:convert';

import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyChallengeStorage {
  DailyChallengeStorage(this._prefs);

  static const String _key = 'rps_duel.daily_challenge.v1';

  final SharedPreferences _prefs;

  static Future<DailyChallengeStorage> open() async {
    final prefs = await SharedPreferences.getInstance();
    return DailyChallengeStorage(prefs);
  }

  DailyChallenge? load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      return DailyChallenge.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(DailyChallenge challenge) async {
    await _prefs.setString(_key, jsonEncode(challenge.toJson()));
  }
}
