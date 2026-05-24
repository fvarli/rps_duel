import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/data/local_difficulty_storage.dart';
import 'package:rps_duel/domain/cpu_difficulty.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DifficultyStorage', () {
    test('load returns normal when nothing is stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await DifficultyStorage.open();
      expect(storage.load(), CpuDifficulty.normal);
    });

    test('save + load roundtrip preserves the difficulty', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await DifficultyStorage.open();

      await storage.save(CpuDifficulty.hard);
      expect(storage.load(), CpuDifficulty.hard);

      await storage.save(CpuDifficulty.easy);
      expect(storage.load(), CpuDifficulty.easy);
    });

    test('load returns normal on a corrupt stored value', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.difficulty.v1': 'not-a-difficulty',
      });
      final storage = await DifficultyStorage.open();
      expect(storage.load(), CpuDifficulty.normal);
    });
  });
}
