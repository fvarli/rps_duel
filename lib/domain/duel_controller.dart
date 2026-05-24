import 'dart:async';

import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/duel_state.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';
import 'package:rps_duel/domain/rps_engine.dart';

class DuelController {
  DuelController({
    RpsEngine? engine,
    DateTime Function()? now,
    Duration cpuThinkingDelay = const Duration(milliseconds: 500),
  })  : _engine = engine ?? RpsEngine(),
        _now = now ?? DateTime.now,
        _cpuThinkingDelay = cpuThinkingDelay;

  final RpsEngine _engine;
  final DateTime Function() _now;
  final Duration _cpuThinkingDelay;
  DuelState _state = DuelState.initial();

  void Function()? onStateChanged;

  DuelState get state => _state;

  void _setState(DuelState newState) {
    _state = newState;
    onStateChanged?.call();
  }

  DuelState selectMove(MoveChoice move) {
    final cpu = _engine.cpuMove();
    final outcome = _engine.resolve(playerMove: move, cpuMove: cpu);
    final record = RoundRecord(
      playerMove: move,
      cpuMove: cpu,
      outcome: outcome,
      timestamp: _now(),
    );

    final newCurrentStreak =
        outcome == RoundOutcome.playerWin ? _state.currentStreak + 1 : 0;
    final newBestStreak = newCurrentStreak > _state.bestStreak
        ? newCurrentStreak
        : _state.bestStreak;

    _setState(DuelState(
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
      currentStreak: newCurrentStreak,
      bestStreak: newBestStreak,
    ),);
    return _state;
  }

  Future<DuelState> selectMoveWithDelay(MoveChoice move) async {
    _setState(DuelState(
      phase: DuelPhase.playerSelected,
      playerMove: move,
      cpuMove: null,
      outcome: null,
      playerScore: _state.playerScore,
      cpuScore: _state.cpuScore,
      ties: _state.ties,
      roundCount: _state.roundCount,
      history: _state.history,
      currentStreak: _state.currentStreak,
      bestStreak: _state.bestStreak,
    ),);
    _setState(DuelState(
      phase: DuelPhase.cpuThinking,
      playerMove: move,
      cpuMove: null,
      outcome: null,
      playerScore: _state.playerScore,
      cpuScore: _state.cpuScore,
      ties: _state.ties,
      roundCount: _state.roundCount,
      history: _state.history,
      currentStreak: _state.currentStreak,
      bestStreak: _state.bestStreak,
    ),);
    await Future<void>.delayed(_cpuThinkingDelay);
    if (_state.phase != DuelPhase.cpuThinking) {
      return _state;
    }
    return selectMove(move);
  }

  DuelState nextRound() {
    _setState(DuelState(
      phase: DuelPhase.idle,
      playerMove: null,
      cpuMove: null,
      outcome: null,
      playerScore: _state.playerScore,
      cpuScore: _state.cpuScore,
      ties: _state.ties,
      roundCount: _state.roundCount,
      history: _state.history,
      currentStreak: _state.currentStreak,
      bestStreak: _state.bestStreak,
    ),);
    return _state;
  }

  DuelState reset() {
    _setState(DuelState.initial());
    return _state;
  }

  void restoreFrom(DuelState state) {
    _setState(state);
  }
}
