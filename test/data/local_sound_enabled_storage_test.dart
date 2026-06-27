import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/data/local_sound_enabled_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SoundEnabledStorage', () {
    test('load defaults to true when nothing is stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await SoundEnabledStorage.open();
      expect(storage.load(), isTrue);
    });

    test('save + load roundtrip preserves true', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await SoundEnabledStorage.open();
      await storage.save(true);
      expect(storage.load(), isTrue);
    });

    test('save + load roundtrip preserves false', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await SoundEnabledStorage.open();
      await storage.save(false);
      expect(storage.load(), isFalse);
    });

    test('persisted false survives a fresh storage instance', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.sound_enabled.v1': false,
      });
      final storage = await SoundEnabledStorage.open();
      expect(storage.load(), isFalse);
    });
  });
}
