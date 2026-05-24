import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/rps_engine.dart';

void main() {
  group('RpsEngine.resolve — 9-case truth table', () {
    final engine = RpsEngine();

    test('rock vs rock → tie', () {
      expect(
        engine.resolve(playerMove: MoveChoice.rock, cpuMove: MoveChoice.rock),
        RoundOutcome.tie,
      );
    });

    test('rock vs paper → cpuWin', () {
      expect(
        engine.resolve(playerMove: MoveChoice.rock, cpuMove: MoveChoice.paper),
        RoundOutcome.cpuWin,
      );
    });

    test('rock vs scissors → playerWin', () {
      expect(
        engine.resolve(
          playerMove: MoveChoice.rock,
          cpuMove: MoveChoice.scissors,
        ),
        RoundOutcome.playerWin,
      );
    });

    test('paper vs rock → playerWin', () {
      expect(
        engine.resolve(playerMove: MoveChoice.paper, cpuMove: MoveChoice.rock),
        RoundOutcome.playerWin,
      );
    });

    test('paper vs paper → tie', () {
      expect(
        engine.resolve(playerMove: MoveChoice.paper, cpuMove: MoveChoice.paper),
        RoundOutcome.tie,
      );
    });

    test('paper vs scissors → cpuWin', () {
      expect(
        engine.resolve(
          playerMove: MoveChoice.paper,
          cpuMove: MoveChoice.scissors,
        ),
        RoundOutcome.cpuWin,
      );
    });

    test('scissors vs rock → cpuWin', () {
      expect(
        engine.resolve(
          playerMove: MoveChoice.scissors,
          cpuMove: MoveChoice.rock,
        ),
        RoundOutcome.cpuWin,
      );
    });

    test('scissors vs paper → playerWin', () {
      expect(
        engine.resolve(
          playerMove: MoveChoice.scissors,
          cpuMove: MoveChoice.paper,
        ),
        RoundOutcome.playerWin,
      );
    });

    test('scissors vs scissors → tie', () {
      expect(
        engine.resolve(
          playerMove: MoveChoice.scissors,
          cpuMove: MoveChoice.scissors,
        ),
        RoundOutcome.tie,
      );
    });
  });

  group('RpsEngine.cpuMove — returns valid MoveChoice', () {
    test('1000 invocations all return a valid enum value', () {
      final engine = RpsEngine();
      for (var i = 0; i < 1000; i++) {
        final move = engine.cpuMove();
        expect(MoveChoice.values, contains(move));
      }
    });
  });
}
