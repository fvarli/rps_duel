import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';

void main() {
  group('DailyChallenge', () {
    test("initialFor builds 0/3, not completed, with today's local date", () {
      final c = DailyChallenge.initialFor(DateTime(2026, 5, 24, 14, 30));
      expect(c.date, '2026-05-24');
      expect(c.progress, 0);
      expect(c.completed, isFalse);
      expect(c.isToday(DateTime(2026, 5, 24, 23, 59)), isTrue);
      expect(c.isToday(DateTime(2026, 5, 25, 0, 1)), isFalse);
    });

    test('advanceFor increments on player win with scissors', () {
      var c = DailyChallenge.initialFor(DateTime(2026, 5, 24));
      c = c.advanceFor(MoveChoice.scissors, RoundOutcome.playerWin);
      expect(c.progress, 1);
      expect(c.completed, isFalse);
    });

    test('advanceFor does not increment on a non-scissors player win', () {
      var c = DailyChallenge.initialFor(DateTime(2026, 5, 24));
      c = c.advanceFor(MoveChoice.rock, RoundOutcome.playerWin);
      c = c.advanceFor(MoveChoice.paper, RoundOutcome.playerWin);
      expect(c.progress, 0);
      expect(c.completed, isFalse);
    });

    test('advanceFor does not increment on scissors loss or tie', () {
      var c = DailyChallenge.initialFor(DateTime(2026, 5, 24));
      c = c.advanceFor(MoveChoice.scissors, RoundOutcome.cpuWin);
      c = c.advanceFor(MoveChoice.scissors, RoundOutcome.tie);
      expect(c.progress, 0);
      expect(c.completed, isFalse);
    });

    test('advanceFor completes at 3/3 and is capped beyond that', () {
      var c = DailyChallenge.initialFor(DateTime(2026, 5, 24));
      c = c.advanceFor(MoveChoice.scissors, RoundOutcome.playerWin);
      c = c.advanceFor(MoveChoice.scissors, RoundOutcome.playerWin);
      c = c.advanceFor(MoveChoice.scissors, RoundOutcome.playerWin);
      expect(c.progress, 3);
      expect(c.completed, isTrue);

      c = c.advanceFor(MoveChoice.scissors, RoundOutcome.playerWin);
      expect(c.progress, 3);
      expect(c.completed, isTrue);
    });
  });
}
