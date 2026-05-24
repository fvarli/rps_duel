import 'package:rps_duel/domain/cpu_difficulty.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DifficultyStorage {
  DifficultyStorage(this._prefs);

  static const String _key = 'rps_duel.difficulty.v1';

  final SharedPreferences _prefs;

  static Future<DifficultyStorage> open() async {
    final prefs = await SharedPreferences.getInstance();
    return DifficultyStorage(prefs);
  }

  CpuDifficulty load() {
    final name = _prefs.getString(_key);
    if (name == null) return CpuDifficulty.normal;
    try {
      return CpuDifficulty.values.byName(name);
    } catch (_) {
      return CpuDifficulty.normal;
    }
  }

  Future<void> save(CpuDifficulty difficulty) async {
    await _prefs.setString(_key, difficulty.name);
  }
}
