import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:rps_duel/domain/daily_challenge_kind.dart';
import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/duel_state.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';

DuelState _stateWithStreak(int streak) {
  return DuelState(
    phase: DuelPhase.reveal,
    playerScore: streak,
    cpuScore: 0,
    ties: 0,
    roundCount: streak,
    history: const [],
    currentStreak: streak,
    bestStreak: streak,
    playerMove: MoveChoice.rock,
    cpuMove: MoveChoice.scissors,
    outcome: RoundOutcome.playerWin,
  );
}

void main() {
  group('DailyChallenge', () {
    test("initialFor builds 0/target, not completed, with today's local date",
        () {
      final c = DailyChallenge.initialFor(DateTime(2026, 5, 24, 14, 30));
      expect(c.date, '2026-05-24');
      expect(c.progress, 0);
      expect(c.completed, isFalse);
      expect(c.target, greaterThan(0));
      expect(c.isToday(DateTime(2026, 5, 24, 23, 59)), isTrue);
      expect(c.isToday(DateTime(2026, 5, 25, 0, 1)), isFalse);
    });

    test('winRounds kind advances on any player win', () {
      var c = const DailyChallenge(
        date: '2026-05-24',
        kind: DailyChallengeKind.winRounds,
        target: 3,
        progress: 0,
        completed: false,
      );
      c = c.advanceFor(
        playerMove: MoveChoice.rock,
        outcome: RoundOutcome.playerWin,
        state: _stateWithStreak(1),
      );
      expect(c.progress, 1);
      expect(c.completed, isFalse);
    });

    test('winWithScissors preserves the legacy scissors-only rule', () {
      var c = const DailyChallenge(
        date: '2026-05-24',
        kind: DailyChallengeKind.winWithScissors,
        target: 3,
        progress: 0,
        completed: false,
      );
      // Non-scissors wins do not count.
      c = c.advanceFor(
        playerMove: MoveChoice.rock,
        outcome: RoundOutcome.playerWin,
        state: _stateWithStreak(1),
      );
      c = c.advanceFor(
        playerMove: MoveChoice.paper,
        outcome: RoundOutcome.playerWin,
        state: _stateWithStreak(2),
      );
      expect(c.progress, 0);
      // Scissors loss / tie does not count.
      c = c.advanceFor(
        playerMove: MoveChoice.scissors,
        outcome: RoundOutcome.cpuWin,
        state: _stateWithStreak(0),
      );
      c = c.advanceFor(
        playerMove: MoveChoice.scissors,
        outcome: RoundOutcome.tie,
        state: _stateWithStreak(0),
      );
      expect(c.progress, 0);
      // Scissors win bumps.
      c = c.advanceFor(
        playerMove: MoveChoice.scissors,
        outcome: RoundOutcome.playerWin,
        state: _stateWithStreak(1),
      );
      expect(c.progress, 1);
    });

    test('getTies kind advances on any tie regardless of move', () {
      var c = const DailyChallenge(
        date: '2026-05-24',
        kind: DailyChallengeKind.getTies,
        target: 2,
        progress: 0,
        completed: false,
      );
      c = c.advanceFor(
        playerMove: MoveChoice.paper,
        outcome: RoundOutcome.tie,
        state: _stateWithStreak(0),
      );
      expect(c.progress, 1);
      c = c.advanceFor(
        playerMove: MoveChoice.scissors,
        outcome: RoundOutcome.tie,
        state: _stateWithStreak(0),
      );
      expect(c.progress, 2);
      expect(c.completed, isTrue);
    });

    test('winStreak kind tracks best in-day streak, monotonic across losses',
        () {
      var c = const DailyChallenge(
        date: '2026-05-24',
        kind: DailyChallengeKind.winStreak,
        target: 3,
        progress: 0,
        completed: false,
      );
      // Win, win — progress climbs with the live streak.
      c = c.advanceFor(
        playerMove: MoveChoice.rock,
        outcome: RoundOutcome.playerWin,
        state: _stateWithStreak(1),
      );
      expect(c.progress, 1);
      c = c.advanceFor(
        playerMove: MoveChoice.rock,
        outcome: RoundOutcome.playerWin,
        state: _stateWithStreak(2),
      );
      expect(c.progress, 2);
      // Lose. Live streak resets to 0 but progress holds at 2 — best so far.
      c = c.advanceFor(
        playerMove: MoveChoice.paper,
        outcome: RoundOutcome.cpuWin,
        state: _stateWithStreak(0),
      );
      expect(c.progress, 2);
      // Win three in a row — best becomes 3, challenge completes.
      c = c.advanceFor(
        playerMove: MoveChoice.rock,
        outcome: RoundOutcome.playerWin,
        state: _stateWithStreak(1),
      );
      c = c.advanceFor(
        playerMove: MoveChoice.rock,
        outcome: RoundOutcome.playerWin,
        state: _stateWithStreak(2),
      );
      c = c.advanceFor(
        playerMove: MoveChoice.rock,
        outcome: RoundOutcome.playerWin,
        state: _stateWithStreak(3),
      );
      expect(c.progress, 3);
      expect(c.completed, isTrue);
    });

    test('playRounds kind advances on every round, win or lose or tie', () {
      var c = const DailyChallenge(
        date: '2026-05-24',
        kind: DailyChallengeKind.playRounds,
        target: 5,
        progress: 0,
        completed: false,
      );
      for (final outcome in [
        RoundOutcome.playerWin,
        RoundOutcome.cpuWin,
        RoundOutcome.tie,
        RoundOutcome.cpuWin,
        RoundOutcome.playerWin,
      ]) {
        c = c.advanceFor(
          playerMove: MoveChoice.rock,
          outcome: outcome,
          state: _stateWithStreak(0),
        );
      }
      expect(c.progress, 5);
      expect(c.completed, isTrue);
    });

    test('advanceFor caps at target and stays completed', () {
      var c = const DailyChallenge(
        date: '2026-05-24',
        kind: DailyChallengeKind.winRounds,
        target: 3,
        progress: 3,
        completed: true,
      );
      c = c.advanceFor(
        playerMove: MoveChoice.rock,
        outcome: RoundOutcome.playerWin,
        state: _stateWithStreak(1),
      );
      expect(c.progress, 3);
      expect(c.completed, isTrue);
    });

    test('fromJson without kind defaults to winWithScissors (v1 compat)', () {
      final c = DailyChallenge.fromJson(<String, dynamic>{
        'date': '2026-05-24',
        'progress': 2,
        'completed': false,
      });
      expect(c.kind, DailyChallengeKind.winWithScissors);
      expect(c.target, 3);
      expect(c.progress, 2);
      expect(c.date, '2026-05-24');
    });

    test('fromJson with unknown kind falls back to playRounds', () {
      final c = DailyChallenge.fromJson(<String, dynamic>{
        'date': '2026-05-24',
        'kind': 'someFutureChallengeKind',
        'target': 7,
        'progress': 0,
        'completed': false,
      });
      expect(c.kind, DailyChallengeKind.playRounds);
      // Forward-supplied target is honored even on fallback.
      expect(c.target, 7);
    });

    test('toJson roundtrips through fromJson with all v2 fields preserved', () {
      const original = DailyChallenge(
        date: '2026-05-24',
        kind: DailyChallengeKind.winStreak,
        target: 3,
        progress: 2,
        completed: false,
      );
      final restored = DailyChallenge.fromJson(original.toJson());
      expect(restored.date, original.date);
      expect(restored.kind, original.kind);
      expect(restored.target, original.target);
      expect(restored.progress, original.progress);
      expect(restored.completed, original.completed);
    });
  });
}
