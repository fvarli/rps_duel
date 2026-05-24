import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/data/local_locale_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocaleStorage', () {
    test('load returns null when nothing is stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await LocaleStorage.open();
      expect(storage.load(), isNull);
    });

    test('save + load roundtrip preserves the language code', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await LocaleStorage.open();

      await storage.save(const Locale('tr'));
      expect(storage.load(), const Locale('tr'));

      await storage.save(const Locale('es'));
      expect(storage.load(), const Locale('es'));
    });

    test('save(null) clears the key', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.locale.v1': 'es',
      });
      final storage = await LocaleStorage.open();
      expect(storage.load(), const Locale('es'));

      await storage.save(null);
      expect(storage.load(), isNull);
    });
  });
}
