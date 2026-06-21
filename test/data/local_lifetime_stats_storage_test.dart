import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/data/local_lifetime_stats_storage.dart';
import 'package:rps_duel/domain/lifetime_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LifetimeStatsStorage', () {
    test('load returns null when nothing is stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await LifetimeStatsStorage.open();
      // Null is the "fresh install" signal — distinguishes from a
      // zeroed blob (which means "everything is genuinely zero").
      expect(storage.load(), isNull);
    });

    test('save + load roundtrip preserves all three totals', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await LifetimeStatsStorage.open();
      await storage.save(
        const LifetimeStats(totalRounds: 247, totalWins: 89, totalTies: 18),
      );
      final restored = storage.load();
      expect(restored, isNotNull);
      expect(restored!.totalRounds, 247);
      expect(restored.totalWins, 89);
      expect(restored.totalTies, 18);
    });

    test('load returns zero stats on corrupt JSON', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.lifetime_stats.v1': 'not valid json {{{',
      });
      final storage = await LifetimeStatsStorage.open();
      final loaded = storage.load();
      expect(loaded, isNotNull);
      expect(loaded!.totalRounds, 0);
      expect(loaded.totalWins, 0);
      expect(loaded.totalTies, 0);
    });

    test('load fills missing fields with 0 (partial blob, forward-compat)',
        () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.lifetime_stats.v1': '{"totalRounds":5}',
      });
      final storage = await LifetimeStatsStorage.open();
      final loaded = storage.load();
      expect(loaded!.totalRounds, 5);
      expect(loaded.totalWins, 0);
      expect(loaded.totalTies, 0);
    });
  });
}
