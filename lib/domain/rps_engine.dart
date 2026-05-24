import 'dart:math';

import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';

class RpsEngine {
  RpsEngine({Random? random}) : _random = random ?? Random();

  final Random _random;

  MoveChoice cpuMove() =>
      MoveChoice.values[_random.nextInt(MoveChoice.values.length)];

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
