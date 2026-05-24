import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/data/local_daily_challenge_storage.dart';
import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DailyChallengeStorage', () {
    test('load returns null when nothing is stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await DailyChallengeStorage.open();
      expect(storage.load(), isNull);
    });

    test('save + load roundtrip preserves date/progress/completed', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await DailyChallengeStorage.open();

      const original = DailyChallenge(
        date: '2026-05-24',
        progress: 2,
        completed: false,
      );
      await storage.save(original);
      final restored = storage.load();

      expect(restored, isNotNull);
      expect(restored!.date, '2026-05-24');
      expect(restored.progress, 2);
      expect(restored.completed, isFalse);

      const completed = DailyChallenge(
        date: '2026-05-24',
        progress: 3,
        completed: true,
      );
      await storage.save(completed);
      expect(storage.load()!.completed, isTrue);
    });

    test('load returns null on corrupt JSON', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.daily_challenge.v1': 'not valid json {{{',
      });
      final storage = await DailyChallengeStorage.open();
      expect(storage.load(), isNull);
    });
  });
}
