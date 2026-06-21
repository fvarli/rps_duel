import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/data/local_achievement_storage.dart';
import 'package:rps_duel/domain/achievement.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AchievementStorage', () {
    test('save + load roundtrip preserves entries and timestamps', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await AchievementStorage.open();
      final at = DateTime.utc(2026, 6, 20, 12, 30);
      await storage.save(<AchievementId, DateTime?>{
        AchievementId.firstWin: at,
        AchievementId.streak3: null,
      });
      final loaded = storage.load();
      expect(
        loaded.keys.toSet(),
        equals(<AchievementId>{AchievementId.firstWin, AchievementId.streak3}),
      );
      expect(loaded[AchievementId.firstWin], equals(at));
      expect(loaded[AchievementId.streak3], isNull);
    });

    test('load silently ignores unknown enum names', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.achievements.v2':
            '{"firstWin":null,"someGhostAchievement":"2026-01-01T00:00:00.000Z","streak3":null}',
      });
      final storage = await AchievementStorage.open();
      expect(
        storage.load().keys.toSet(),
        equals(<AchievementId>{AchievementId.firstWin, AchievementId.streak3}),
      );
    });

    test('migrates v1 set to v2 map with null timestamps and clears v1',
        () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.achievements.v1': <String>[
          'firstWin',
          'first10Rounds',
        ],
      });
      final storage = await AchievementStorage.open();
      final loaded = storage.load();
      expect(
        loaded.keys.toSet(),
        equals(<AchievementId>{
          AchievementId.firstWin,
          AchievementId.first10Rounds,
        }),
      );
      // Migrated entries have unknown unlock time.
      expect(loaded[AchievementId.firstWin], isNull);
      expect(loaded[AchievementId.first10Rounds], isNull);
      // v1 key is gone after migration.
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('rps_duel.achievements.v1'), isFalse);
      expect(prefs.containsKey('rps_duel.achievements.v2'), isTrue);
    });

    test('does not re-migrate when v2 key already exists', () async {
      // Both keys present — v2 should win, v1 should be left alone (we only
      // clear v1 when we perform a migration).
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.achievements.v1': <String>['streak3'],
        'flutter.rps_duel.achievements.v2': '{"firstWin":null}',
      });
      final storage = await AchievementStorage.open();
      expect(
        storage.load().keys.toSet(),
        equals(<AchievementId>{AchievementId.firstWin}),
      );
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('rps_duel.achievements.v1'), isTrue);
    });
  });
}
