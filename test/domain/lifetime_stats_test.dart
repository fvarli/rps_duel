import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/domain/lifetime_stats.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';

RoundRecord _round(RoundOutcome outcome) {
  return RoundRecord(
    playerMove: MoveChoice.rock,
    cpuMove: MoveChoice.scissors,
    outcome: outcome,
    timestamp: DateTime.utc(2026, 6, 22, 12),
  );
}

void main() {
  group('LifetimeStats', () {
    test('zero factory yields all-zero totals', () {
      final z = LifetimeStats.zero();
      expect(z.totalRounds, 0);
      expect(z.totalWins, 0);
      expect(z.totalTies, 0);
    });

    test('JSON roundtrip preserves all three fields', () {
      const original = LifetimeStats(
        totalRounds: 247,
        totalWins: 89,
        totalTies: 18,
      );
      final restored = LifetimeStats.fromJson(original.toJson());
      expect(restored.totalRounds, 247);
      expect(restored.totalWins, 89);
      expect(restored.totalTies, 18);
    });

    test('fromJson defaults missing fields to 0 (forward-compat)', () {
      final restored = LifetimeStats.fromJson(<String, dynamic>{
        'totalRounds': 5,
      });
      expect(restored.totalRounds, 5);
      expect(restored.totalWins, 0);
      expect(restored.totalTies, 0);
    });
  });

  group('incrementLifetimeFor', () {
    test('player win bumps totalRounds and totalWins, not ties', () {
      final result = incrementLifetimeFor(
        const LifetimeStats(totalRounds: 10, totalWins: 4, totalTies: 1),
        _round(RoundOutcome.playerWin),
      );
      expect(result.totalRounds, 11);
      expect(result.totalWins, 5);
      expect(result.totalTies, 1);
    });

    test('CPU win bumps only totalRounds', () {
      final result = incrementLifetimeFor(
        LifetimeStats.zero(),
        _round(RoundOutcome.cpuWin),
      );
      expect(result.totalRounds, 1);
      expect(result.totalWins, 0);
      expect(result.totalTies, 0);
    });

    test('tie bumps totalRounds and totalTies, not wins', () {
      final result = incrementLifetimeFor(
        LifetimeStats.zero(),
        _round(RoundOutcome.tie),
      );
      expect(result.totalRounds, 1);
      expect(result.totalWins, 0);
      expect(result.totalTies, 1);
    });

    test('monotonic: a sequence of varied outcomes increments correctly', () {
      var s = LifetimeStats.zero();
      for (final outcome in [
        RoundOutcome.playerWin,
        RoundOutcome.cpuWin,
        RoundOutcome.tie,
        RoundOutcome.playerWin,
        RoundOutcome.playerWin,
        RoundOutcome.tie,
      ]) {
        s = incrementLifetimeFor(s, _round(outcome));
      }
      expect(s.totalRounds, 6);
      expect(s.totalWins, 3);
      expect(s.totalTies, 2);
    });
  });
}
