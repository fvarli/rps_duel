import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleStorage {
  LocaleStorage(this._prefs);

  static const String _key = 'rps_duel.locale.v1';

  final SharedPreferences _prefs;

  static Future<LocaleStorage> open() async {
    final prefs = await SharedPreferences.getInstance();
    return LocaleStorage(prefs);
  }

  Locale? load() {
    final code = _prefs.getString(_key);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> save(Locale? locale) async {
    if (locale == null) {
      await _prefs.remove(_key);
    } else {
      await _prefs.setString(_key, locale.languageCode);
    }
  }
}
