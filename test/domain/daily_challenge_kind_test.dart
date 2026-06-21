import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/domain/daily_challenge_kind.dart';

void main() {
  group('DailyChallengeKind rotation', () {
    test('the same local date always maps to the same kind', () {
      final a = dailyChallengeKindFor('2026-05-24');
      final b = dailyChallengeKindFor('2026-05-24');
      expect(a, equals(b));
    });

    test('adjacent dates map to distinct or stable kinds, no Math.random drift',
        () {
      // Determinism check: build the rotation on a fresh Dart isolate and
      // it must produce the same sequence as on a warmed one. We simulate
      // by hashing twice and comparing.
      for (final date in <String>[
        '2026-06-21',
        '2026-06-22',
        '2026-06-23',
        '2026-06-24',
        '2026-12-31',
        '2027-01-01',
      ]) {
        expect(
          dailyChallengeKindFor(date),
          equals(dailyChallengeKindFor(date)),
        );
      }
    });

    test('rotation covers every kind across a representative date span', () {
      // Walk a year of dates and assert every archetype shows up at least
      // once — the library is small enough that uneven coverage would be a
      // tuning failure, not just luck.
      final seen = <DailyChallengeKind>{};
      for (var day = 0; day < 365; day++) {
        final d = DateTime(2026, 1, 1).add(Duration(days: day));
        final date = '${d.year.toString().padLeft(4, '0')}-'
            '${d.month.toString().padLeft(2, '0')}-'
            '${d.day.toString().padLeft(2, '0')}';
        seen.add(dailyChallengeKindFor(date));
      }
      expect(seen, equals(DailyChallengeKind.values.toSet()));
    });

    test('targetFor returns a positive integer for every kind', () {
      for (final kind in DailyChallengeKind.values) {
        expect(targetFor(kind), greaterThan(0));
      }
    });
  });
}
