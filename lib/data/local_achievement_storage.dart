import 'package:rps_duel/domain/achievement.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementStorage {
  AchievementStorage(this._prefs);

  static const String _key = 'rps_duel.achievements.v1';

  final SharedPreferences _prefs;

  static Future<AchievementStorage> open() async {
    final prefs = await SharedPreferences.getInstance();
    return AchievementStorage(prefs);
  }

  Set<AchievementId> load() {
    final list = _prefs.getStringList(_key);
    if (list == null) return <AchievementId>{};
    final out = <AchievementId>{};
    for (final name in list) {
      try {
        out.add(AchievementId.values.byName(name));
      } catch (_) {
        // Unknown enum name — forward-compat / corrupt entry. Skip silently.
      }
    }
    return out;
  }

  Future<void> save(Set<AchievementId> ids) async {
    await _prefs.setStringList(
      _key,
      ids.map((id) => id.name).toList(),
    );
  }
}
