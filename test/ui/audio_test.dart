import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/ui/audio.dart';

void main() {
  setUp(Audio.debugReset);
  tearDown(Audio.debugReset);

  group('Audio toggle gating', () {
    test('plays through the override when enabled', () {
      final played = <String>[];
      Audio.debugPlayOverride = played.add;

      Audio.tap();
      Audio.reveal();
      Audio.win();
      Audio.loss();
      Audio.tie();
      Audio.unlock();

      expect(played, <String>[
        'sounds/tap.wav',
        'sounds/reveal.wav',
        'sounds/win.wav',
        'sounds/loss.wav',
        'sounds/tie.wav',
        'sounds/unlock.wav',
      ]);
    });

    test('records nothing when disabled', () {
      final played = <String>[];
      Audio.debugPlayOverride = played.add;
      Audio.setEnabled(false);

      Audio.tap();
      Audio.win();
      Audio.unlock();

      expect(played, isEmpty);
      expect(Audio.isEnabled, isFalse);
    });

    test('isEnabled defaults to true on a fresh process', () {
      // debugReset re-runs in setUp; mirrors the initial state.
      expect(Audio.isEnabled, isTrue);
    });

    test('setEnabled(false) followed by setEnabled(true) re-enables playback',
        () {
      final played = <String>[];
      Audio.debugPlayOverride = played.add;

      Audio.setEnabled(false);
      Audio.tap();
      expect(played, isEmpty);

      Audio.setEnabled(true);
      Audio.tap();
      expect(played, <String>['sounds/tap.wav']);
    });
  });
}
