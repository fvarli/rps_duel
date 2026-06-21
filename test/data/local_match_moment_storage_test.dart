import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/data/local_match_moment_storage.dart';
import 'package:rps_duel/domain/match_moment.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('MatchMomentStorage', () {
    test('load returns empty when nothing is stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await MatchMomentStorage.open();
      expect(storage.load(), isEmpty);
    });

    test('save + load roundtrip preserves entries with dates', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await MatchMomentStorage.open();
      await storage.save(<MatchMomentId, MatchMomentRecord>{
        MatchMomentId.firstWin: const MatchMomentRecord(date: '2026-06-20'),
        MatchMomentId.rivalBreaker: const MatchMomentRecord(date: '2026-06-21'),
      });
      final restored = storage.load();
      expect(restored.keys.toSet(), <MatchMomentId>{
        MatchMomentId.firstWin,
        MatchMomentId.rivalBreaker,
      });
      expect(restored[MatchMomentId.firstWin]!.date, '2026-06-20');
      expect(restored[MatchMomentId.rivalBreaker]!.date, '2026-06-21');
    });

    test('load silently skips unknown moment names (forward-compat)', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.match_moments.v1':
            '{"firstWin":{"date":"2026-06-20"},"someFutureMoment":{"date":"2026-06-21"},'
                '"counterMaster":{"date":"2026-06-22"}}',
      });
      final storage = await MatchMomentStorage.open();
      final loaded = storage.load();
      expect(loaded.keys.toSet(), <MatchMomentId>{
        MatchMomentId.firstWin,
        MatchMomentId.counterMaster,
      });
    });

    test('load returns empty map on corrupt JSON', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.match_moments.v1': 'not valid json {{{',
      });
      final storage = await MatchMomentStorage.open();
      expect(storage.load(), isEmpty);
    });
  });
}
