import 'dart:math';

import 'package:rps_duel/domain/cpu_difficulty.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';

class RpsEngine {
  RpsEngine({Random? random}) : _random = random ?? Random();

  final Random _random;

  MoveChoice cpuMove() =>
      MoveChoice.values[_random.nextInt(MoveChoice.values.length)];

  MoveChoice cpuMoveFor({
    required MoveChoice playerMove,
    required CpuDifficulty difficulty,
  }) {
    switch (difficulty) {
      case CpuDifficulty.normal:
        return cpuMove();
      case CpuDifficulty.easy:
        final r = _random.nextInt(100);
        if (r < 60) return _losesToMove(playerMove);
        if (r < 80) return playerMove;
        return _beatsMove(playerMove);
      case CpuDifficulty.hard:
        final r = _random.nextInt(100);
        if (r < 60) return _beatsMove(playerMove);
        if (r < 80) return playerMove;
        return _losesToMove(playerMove);
    }
  }

  RoundOutcome resolve({
    required MoveChoice playerMove,
    required MoveChoice cpuMove,
  }) {
    return switch ((playerMove, cpuMove)) {
      (MoveChoice.rock, MoveChoice.rock) => RoundOutcome.tie,
      (MoveChoice.rock, MoveChoice.paper) => RoundOutcome.cpuWin,
      (MoveChoice.rock, MoveChoice.scissors) => RoundOutcome.playerWin,
      (MoveChoice.paper, MoveChoice.rock) => RoundOutcome.playerWin,
      (MoveChoice.paper, MoveChoice.paper) => RoundOutcome.tie,
      (MoveChoice.paper, MoveChoice.scissors) => RoundOutcome.cpuWin,
      (MoveChoice.scissors, MoveChoice.rock) => RoundOutcome.cpuWin,
      (MoveChoice.scissors, MoveChoice.paper) => RoundOutcome.playerWin,
      (MoveChoice.scissors, MoveChoice.scissors) => RoundOutcome.tie,
    };
  }
}

MoveChoice _beatsMove(MoveChoice m) => switch (m) {
      MoveChoice.rock => MoveChoice.paper,
      MoveChoice.paper => MoveChoice.scissors,
      MoveChoice.scissors => MoveChoice.rock,
    };

MoveChoice _losesToMove(MoveChoice m) => switch (m) {
      MoveChoice.rock => MoveChoice.scissors,
      MoveChoice.paper => MoveChoice.rock,
      MoveChoice.scissors => MoveChoice.paper,
    };
