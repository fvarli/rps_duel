import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/domain/cpu_difficulty.dart';
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

  @override
  MoveChoice cpuMoveFor({
    required MoveChoice playerMove,
    required CpuDifficulty difficulty,
  }) =>
      _cpu;
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

    test('selectMoveWithDelay walks playerSelected → cpuThinking → reveal',
        () async {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
        cpuThinkingDelay: Duration.zero,
      );
      final phases = <DuelPhase>[];
      controller.onStateChanged = () => phases.add(controller.state.phase);

      final result = await controller.selectMoveWithDelay(MoveChoice.rock);

      expect(phases, <DuelPhase>[
        DuelPhase.playerSelected,
        DuelPhase.cpuThinking,
        DuelPhase.reveal,
      ]);
      expect(result.phase, DuelPhase.reveal);
      expect(result.outcome, RoundOutcome.playerWin);
      expect(result.playerScore, 1);
      expect(result.roundCount, 1);
    });

    test('selectMoveWithDelay aborts cleanly if reset() lands mid-thinking',
        () async {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
        cpuThinkingDelay: const Duration(milliseconds: 50),
      );

      final pending = controller.selectMoveWithDelay(MoveChoice.rock);
      controller.reset();
      final result = await pending;

      expect(result.phase, DuelPhase.idle);
      expect(result.playerScore, 0);
      expect(result.roundCount, 0);
      expect(result.history, isEmpty);
    });

    test('player win increments currentStreak and bumps bestStreak', () {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
      );
      controller.selectMove(MoveChoice.rock);
      expect(controller.state.currentStreak, 1);
      expect(controller.state.bestStreak, 1);
      controller.selectMove(MoveChoice.rock);
      expect(controller.state.currentStreak, 2);
      expect(controller.state.bestStreak, 2);
    });

    test('cpu win resets currentStreak but keeps bestStreak', () {
      final winner = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
      );
      winner.selectMove(MoveChoice.rock);
      winner.selectMove(MoveChoice.rock);
      winner.selectMove(MoveChoice.rock);
      expect(winner.state.bestStreak, 3);

      final loser = DuelController(
        engine: _FixedCpuEngine(MoveChoice.paper),
      )..restoreFrom(winner.state);
      loser.selectMove(MoveChoice.rock); // rock vs paper → cpuWin

      expect(loser.state.currentStreak, 0);
      expect(loser.state.bestStreak, 3);
    });

    test('tie resets currentStreak but keeps bestStreak', () {
      final winner = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
      );
      winner.selectMove(MoveChoice.rock);
      expect(winner.state.currentStreak, 1);
      expect(winner.state.bestStreak, 1);

      final tier = DuelController(
        engine: _FixedCpuEngine(MoveChoice.rock),
      )..restoreFrom(winner.state);
      tier.selectMove(MoveChoice.rock); // rock vs rock → tie

      expect(tier.state.currentStreak, 0);
      expect(tier.state.bestStreak, 1);
    });

    test('reset zeros both currentStreak and bestStreak', () {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
      );
      controller.selectMove(MoveChoice.rock);
      controller.selectMove(MoveChoice.rock);
      expect(controller.state.bestStreak, 2);

      controller.reset();
      expect(controller.state.currentStreak, 0);
      expect(controller.state.bestStreak, 0);
    });

    test('controller defaults to normal difficulty and setDifficulty propagates',
        () {
      final controller = DuelController(
        engine: _FixedCpuEngine(MoveChoice.scissors),
      );
      expect(controller.difficulty, CpuDifficulty.normal);

      controller.setDifficulty(CpuDifficulty.hard);
      expect(controller.difficulty, CpuDifficulty.hard);

      controller.selectMove(MoveChoice.rock);
      expect(controller.state.cpuMove, MoveChoice.scissors);
      expect(controller.state.outcome, RoundOutcome.playerWin);
    });
  });
}
