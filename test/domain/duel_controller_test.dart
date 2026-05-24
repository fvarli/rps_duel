import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/domain/duel_controller.dart';
import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/rps_engine.dart';

class _FixedCpuEngine extends RpsEngine {
  _FixedCpuEngine(this._cpu);

  final MoveChoice _cpu;

  @override
  MoveChoice cpuMove() => _cpu;
}

void main() {
  group('DuelController', () {
    test('initial state is idle with zero scores and empty history', () {
      final controller = DuelController();
      final state = controller.state;

      expect(state.phase, DuelPhase.idle);
      expect(state.playerMove, isNull);
      expect(state.cpuMove, isNull);
      expect(state.outcome, isNull);
      expect(state.playerScore, 0);
      expect(state.cpuScore, 0);
      expect(state.ties, 0);
      expect(state.roundCount, 0);
      expect(state.history, isEmpty);
    });

    test('player win increments playerScore', () {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
      );

      final state = controller.selectMove(MoveChoice.rock);

      expect(state.phase, DuelPhase.reveal);
      expect(state.outcome, RoundOutcome.playerWin);
      expect(state.playerScore, 1);
      expect(state.cpuScore, 0);
      expect(state.ties, 0);
      expect(state.roundCount, 1);
      expect(state.playerMove, MoveChoice.rock);
      expect(state.cpuMove, MoveChoice.scissors);
    });

    test('cpu win increments cpuScore', () {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.paper),
      );

      final state = controller.selectMove(MoveChoice.rock);

      expect(state.outcome, RoundOutcome.cpuWin);
      expect(state.playerScore, 0);
      expect(state.cpuScore, 1);
      expect(state.ties, 0);
      expect(state.roundCount, 1);
    });

    test('tie increments ties', () {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.rock),
      );

      final state = controller.selectMove(MoveChoice.rock);

      expect(state.outcome, RoundOutcome.tie);
      expect(state.playerScore, 0);
      expect(state.cpuScore, 0);
      expect(state.ties, 1);
      expect(state.roundCount, 1);
    });

    test('history appends after each round', () {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
      );

      controller.selectMove(MoveChoice.rock);
      controller.selectMove(MoveChoice.rock);
      controller.selectMove(MoveChoice.rock);
      final state = controller.state;

      expect(state.history.length, 3);
      expect(state.roundCount, 3);
      expect(
        state.history.every((r) => r.outcome == RoundOutcome.playerWin),
        isTrue,
      );
      expect(state.playerScore, 3);
    });

    test('nextRound keeps scores/history but clears current choices', () {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
      );
      controller.selectMove(MoveChoice.rock);

      final state = controller.nextRound();

      expect(state.phase, DuelPhase.idle);
      expect(state.playerMove, isNull);
      expect(state.cpuMove, isNull);
      expect(state.outcome, isNull);
      expect(state.playerScore, 1);
      expect(state.cpuScore, 0);
      expect(state.ties, 0);
      expect(state.roundCount, 1);
      expect(state.history.length, 1);
    });

    test('reset clears everything', () {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
      );
      controller.selectMove(MoveChoice.rock);
      controller.selectMove(MoveChoice.rock);

      final state = controller.reset();

      expect(state.phase, DuelPhase.idle);
      expect(state.playerMove, isNull);
      expect(state.cpuMove, isNull);
      expect(state.outcome, isNull);
      expect(state.playerScore, 0);
      expect(state.cpuScore, 0);
      expect(state.ties, 0);
      expect(state.roundCount, 0);
      expect(state.history, isEmpty);
    });

    test("controller's stored state matches the value returned by methods", () {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
      );

      final returned = controller.selectMove(MoveChoice.rock);
      expect(identical(returned, controller.state), isTrue);
    });
  });
}
