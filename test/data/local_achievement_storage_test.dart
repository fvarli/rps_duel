import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/data/local_achievement_storage.dart';
import 'package:rps_duel/domain/achievement.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AchievementStorage', () {
    test('save + load roundtrip preserves the unlocked set', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await AchievementStorage.open();
      await storage.save(<AchievementId>{
        AchievementId.firstWin,
        AchievementId.streak3,
      });
      expect(
        storage.load(),
        equals(<AchievementId>{
          AchievementId.firstWin,
          AchievementId.streak3,
        }),
      );
    });

    test('load silently ignores unknown enum names', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.achievements.v1': <String>[
          'firstWin',
          'someGhostAchievement',
          'streak3',
        ],
      });
      final storage = await AchievementStorage.open();
      expect(
        storage.load(),
        equals(<AchievementId>{
          AchievementId.firstWin,
          AchievementId.streak3,
        }),
      );
    });
  });
}
