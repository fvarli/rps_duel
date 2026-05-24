import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/duel_state.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';
import 'package:rps_duel/domain/rps_engine.dart';

class DuelController {
  DuelController({RpsEngine? engine, DateTime Function()? now})
      : _engine = engine ?? RpsEngine(),
        _now = now ?? DateTime.now;

  final RpsEngine _engine;
  final DateTime Function() _now;
  DuelState _state = DuelState.initial();

  DuelState get state => _state;

  DuelState selectMove(MoveChoice move) {
    final cpu = _engine.cpuMove();
    final outcome = _engine.resolve(playerMove: move, cpuMove: cpu);
    final record = RoundRecord(
      playerMove: move,
      cpuMove: cpu,
      outcome: outcome,
      timestamp: _now(),
    );

    _state = DuelState(
      phase: DuelPhase.reveal,
      playerMove: move,
      cpuMove: cpu,
      outcome: outcome,
      playerScore:
          _state.playerScore + (outcome == RoundOutcome.playerWin ? 1 : 0),
      cpuScore: _state.cpuScore + (outcome == RoundOutcome.cpuWin ? 1 : 0),
      ties: _state.ties + (outcome == RoundOutcome.tie ? 1 : 0),
      roundCount: _state.roundCount + 1,
      history: <RoundRecord>[..._state.history, record],
    );
    return _state;
  }

  DuelState nextRound() {
    _state = DuelState(
      phase: DuelPhase.idle,
      playerMove: null,
      cpuMove: null,
      outcome: null,
      playerScore: _state.playerScore,
      cpuScore: _state.cpuScore,
      ties: _state.ties,
      roundCount: _state.roundCount,
      history: _state.history,
    );
    return _state;
  }

  DuelState reset() {
    _state = DuelState.initial();
    return _state;
  }
}
