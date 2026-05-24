import 'dart:convert';

import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/duel_state.dart';
import 'package:rps_duel/domain/round_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalGameStorage {
  LocalGameStorage(this._prefs);

  static const String _key = 'rps_duel.game_state.v1';

  final SharedPreferences _prefs;

  static Future<LocalGameStorage> open() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalGameStorage(prefs);
  }

  Future<void> save(DuelState state) async {
    final map = <String, Object?>{
      'playerScore': state.playerScore,
      'cpuScore': state.cpuScore,
      'ties': state.ties,
      'roundCount': state.roundCount,
      'history': state.history.map((r) => r.toJson()).toList(),
    };
    await _prefs.setString(_key, jsonEncode(map));
  }

  DuelState? load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final history = (map['history'] as List<dynamic>)
          .map((e) => RoundRecord.fromJson(e as Map<String, dynamic>))
          .toList();
      return DuelState(
        phase: DuelPhase.idle,
        playerMove: null,
        cpuMove: null,
        outcome: null,
        playerScore: map['playerScore'] as int,
        cpuScore: map['cpuScore'] as int,
        ties: map['ties'] as int,
        roundCount: map['roundCount'] as int,
        history: history,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}
