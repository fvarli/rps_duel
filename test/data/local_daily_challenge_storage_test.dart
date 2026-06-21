import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/data/local_daily_challenge_storage.dart';
import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:rps_duel/domain/daily_challenge_kind.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DailyChallengeStorage', () {
    test('load returns null when nothing is stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await DailyChallengeStorage.open();
      expect(storage.load(), isNull);
    });

    test('save + load roundtrip preserves date/kind/target/progress/completed',
        () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await DailyChallengeStorage.open();

      const original = DailyChallenge(
        date: '2026-05-24',
        kind: DailyChallengeKind.winStreak,
        target: 3,
        progress: 2,
        completed: false,
      );
      await storage.save(original);
      final restored = storage.load();

      expect(restored, isNotNull);
      expect(restored!.date, '2026-05-24');
      expect(restored.kind, DailyChallengeKind.winStreak);
      expect(restored.target, 3);
      expect(restored.progress, 2);
      expect(restored.completed, isFalse);
    });

    test('load returns null on corrupt JSON', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.daily_challenge.v2': 'not valid json {{{',
      });
      final storage = await DailyChallengeStorage.open();
      expect(storage.load(), isNull);
    });

    test('migrates v1 record to v2 as winWithScissors and clears v1 key',
        () async {
      // v1 wrote {date, progress, completed} only.
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.daily_challenge.v1':
            '{"date":"2026-05-24","progress":2,"completed":false}',
      });
      final storage = await DailyChallengeStorage.open();
      final loaded = storage.load();
      expect(loaded, isNotNull);
      // Migrated entries are treated as the only v1 rule that ever shipped.
      expect(loaded!.kind, DailyChallengeKind.winWithScissors);
      expect(loaded.date, '2026-05-24');
      expect(loaded.progress, 2);
      expect(loaded.target, 3);
      expect(loaded.completed, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('rps_duel.daily_challenge.v1'), isFalse);
      expect(prefs.containsKey('rps_duel.daily_challenge.v2'), isTrue);
    });

    test('does not re-migrate when v2 key already exists', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.daily_challenge.v1':
            '{"date":"2026-05-23","progress":1,"completed":false}',
        'flutter.rps_duel.daily_challenge.v2':
            '{"date":"2026-05-24","kind":"winRounds","target":3,"progress":0,"completed":false}',
      });
      final storage = await DailyChallengeStorage.open();
      final loaded = storage.load();
      expect(loaded!.date, '2026-05-24');
      expect(loaded.kind, DailyChallengeKind.winRounds);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('rps_duel.daily_challenge.v1'), isTrue);
    });
  });
}
