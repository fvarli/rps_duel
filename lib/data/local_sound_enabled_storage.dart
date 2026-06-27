import 'package:shared_preferences/shared_preferences.dart';

/// Persists the single "Sound" toggle from the settings sheet.
///
/// Defaults to **true** — new installs hear the audio layer until the
/// player turns it off, matching the default-on policy used by haptics.
class SoundEnabledStorage {
  SoundEnabledStorage(this._prefs);

  static const String _key = 'rps_duel.sound_enabled.v1';

  final SharedPreferences _prefs;

  static Future<SoundEnabledStorage> open() async {
    final prefs = await SharedPreferences.getInstance();
    return SoundEnabledStorage(prefs);
  }

  bool load() {
    return _prefs.getBool(_key) ?? true;
  }

  Future<void> save(bool enabled) async {
    await _prefs.setBool(_key, enabled);
  }
}
