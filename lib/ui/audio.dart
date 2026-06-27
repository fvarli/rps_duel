import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Six discrete interaction sounds, gated by a single on/off preference.
///
/// Mirrors the shape of [Haptics] from `lib/ui/haptics.dart` — static
/// methods, fire-and-forget, no UI surface of its own. Tests can plug a
/// recording sink into [debugPlayOverride] to verify gating without
/// touching real platform audio.
///
/// Errors during playback are swallowed silently: a missing asset, a
/// closed audio session, or a platform glitch never crashes the app —
/// silence is preferable to a stack trace mid-duel.
class Audio {
  Audio._();

  /// In-memory mirror of the persisted preference. Defaults to true so
  /// new installs hear the layer until they opt out.
  static bool _enabled = true;

  /// Test-only hook. When non-null, every play request is forwarded to
  /// this function instead of the real audioplayers backend.
  @visibleForTesting
  static void Function(String asset)? debugPlayOverride;

  /// Pool of preloaded players keyed by asset path. Keeping one player
  /// per sound means repeat plays start near-instantly after the first
  /// load — a fresh AudioPlayer per call would re-decode the file
  /// every time.
  static final Map<String, AudioPlayer> _players = <String, AudioPlayer>{};

  static bool get isEnabled => _enabled;

  /// Update the in-memory flag. Persistence is the caller's
  /// responsibility — typically the settings sheet's toggle handler
  /// calls this AND writes to [SoundEnabledStorage].
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Drop every preloaded player. Useful between tests to avoid
  /// platform state leaking across cases.
  @visibleForTesting
  static void debugReset() {
    for (final p in _players.values) {
      try {
        p.dispose();
      } catch (_) {
        // ignore — disposing during teardown should never throw to the test
      }
    }
    _players.clear();
    _enabled = true;
    debugPlayOverride = null;
  }

  static void tap() => _play('sounds/tap.wav');
  static void reveal() => _play('sounds/reveal.wav');
  static void win() => _play('sounds/win.wav');
  static void loss() => _play('sounds/loss.wav');
  static void tie() => _play('sounds/tie.wav');
  static void unlock() => _play('sounds/unlock.wav');

  static void _play(String asset) {
    if (!_enabled) return;
    final override = debugPlayOverride;
    if (override != null) {
      override(asset);
      return;
    }
    final player = _players.putIfAbsent(asset, () {
      final p = AudioPlayer();
      // Stop on completion (keeps the asset cached for low-latency reuse).
      p.setReleaseMode(ReleaseMode.stop).catchError((Object _) {});
      return p;
    });
    // Restart from the head so rapid taps don't queue or overlap with
    // themselves; concurrent DIFFERENT sounds (reveal + win) still
    // layer because each lives on its own player.
    player.stop().catchError((Object _) {});
    player.play(AssetSource(asset)).catchError((Object _) {});
  }
}
