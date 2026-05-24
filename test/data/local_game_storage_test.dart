import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/data/local_game_storage.dart';
import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/duel_state.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocalGameStorage', () {
    test('load returns null when nothing is stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await LocalGameStorage.open();
      expect(storage.load(), isNull);
    });

    test('save + load roundtrip preserves scores and history; '
        'phase is normalized to idle', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await LocalGameStorage.open();

      final state = DuelState(
        // Save with a non-idle phase to verify load normalizes it.
        phase: DuelPhase.reveal,
        playerMove: MoveChoice.rock,
        cpuMove: MoveChoice.scissors,
        outcome: RoundOutcome.playerWin,
        playerScore: 5,
        cpuScore: 3,
        ties: 1,
        roundCount: 9,
        history: <RoundRecord>[
          RoundRecord(
            playerMove: MoveChoice.rock,
            cpuMove: MoveChoice.scissors,
            outcome: RoundOutcome.playerWin,
            timestamp: DateTime.utc(2026, 5, 24, 12, 0),
          ),
          RoundRecord(
            playerMove: MoveChoice.paper,
            cpuMove: MoveChoice.paper,
            outcome: RoundOutcome.tie,
            timestamp: DateTime.utc(2026, 5, 24, 12, 1),
          ),
        ],
        currentStreak: 4,
        bestStreak: 7,
      );

      await storage.save(state);
      final restored = storage.load();

      expect(restored, isNotNull);
      expect(restored!.phase, DuelPhase.idle);
      expect(restored.playerMove, isNull);
      expect(restored.cpuMove, isNull);
      expect(restored.outcome, isNull);
      expect(restored.playerScore, 5);
      expect(restored.cpuScore, 3);
      expect(restored.ties, 1);
      expect(restored.roundCount, 9);
      expect(restored.history, hasLength(2));
      expect(restored.history[0].playerMove, MoveChoice.rock);
      expect(restored.history[0].timestamp, DateTime.utc(2026, 5, 24, 12, 0));
      expect(restored.history[1].outcome, RoundOutcome.tie);
      expect(restored.currentStreak, 4);
      expect(restored.bestStreak, 7);
    });

    test('load handles missing streak fields from an older blob', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.game_state.v1': jsonEncode(<String, Object?>{
          'playerScore': 3,
          'cpuScore': 2,
          'ties': 1,
          'roundCount': 6,
          'history': <Object?>[],
          // NO currentStreak / bestStreak keys (Phase 6-13 blob shape).
        }),
      });
      final storage = await LocalGameStorage.open();
      final loaded = storage.load();
      expect(loaded, isNotNull);
      expect(loaded!.playerScore, 3);
      expect(loaded.cpuScore, 2);
      expect(loaded.ties, 1);
      expect(loaded.roundCount, 6);
      expect(loaded.currentStreak, 0);
      expect(loaded.bestStreak, 0);
    });

    test('load returns null on corrupt JSON', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'flutter.rps_duel.game_state.v1': 'not valid json {{{',
      });
      final storage = await LocalGameStorage.open();
      expect(storage.load(), isNull);
    });

    test('clear removes persisted data', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await LocalGameStorage.open();

      await storage.save(
        DuelState(
          phase: DuelPhase.idle,
          playerMove: null,
          cpuMove: null,
          outcome: null,
          playerScore: 2,
          cpuScore: 1,
          ties: 0,
          roundCount: 3,
          history: const <RoundRecord>[],
        ),
      );
      expect(storage.load(), isNotNull);

      await storage.clear();
      expect(storage.load(), isNull);
    });
  });
}
