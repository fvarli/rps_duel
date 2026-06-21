import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/duel_state.dart';
import 'package:rps_duel/domain/match_moment.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';

DateTime _ts(int day) => DateTime.utc(2026, 6, day, 12);

RoundRecord _round({
  required MoveChoice player,
  required MoveChoice cpu,
  required RoundOutcome outcome,
  int day = 21,
}) {
  return RoundRecord(
    playerMove: player,
    cpuMove: cpu,
    outcome: outcome,
    timestamp: _ts(day),
  );
}

RoundRecord _playerWin(MoveChoice cpu, {int day = 21}) {
  final counter = switch (cpu) {
    MoveChoice.rock => MoveChoice.paper,
    MoveChoice.paper => MoveChoice.scissors,
    MoveChoice.scissors => MoveChoice.rock,
  };
  return _round(
    player: counter,
    cpu: cpu,
    outcome: RoundOutcome.playerWin,
    day: day,
  );
}

RoundRecord _cpuWin({int day = 21}) {
  return _round(
    player: MoveChoice.rock,
    cpu: MoveChoice.paper,
    outcome: RoundOutcome.cpuWin,
    day: day,
  );
}

DuelState _state({
  required List<RoundRecord> history,
  int playerScore = 0,
  int cpuScore = 0,
  int currentStreak = 0,
}) {
  return DuelState(
    phase: DuelPhase.reveal,
    playerMove: null,
    cpuMove: null,
    outcome: null,
    playerScore: playerScore,
    cpuScore: cpuScore,
    ties: 0,
    roundCount: history.length,
    history: history,
    currentStreak: currentStreak,
    bestStreak: currentStreak,
  );
}

const _now = _NowProvider();

class _NowProvider {
  const _NowProvider();
  DateTime call() => DateTime(2026, 6, 21, 12);
}

void main() {
  group('detectMoments', () {
    test('firstWin fires once playerScore >= 1', () {
      final result = detectMoments(
        state: _state(
          history: [_playerWin(MoveChoice.scissors)],
          playerScore: 1,
        ),
        already: const <MatchMomentId>{},
        now: _now(),
      );
      expect(result.keys, contains(MatchMomentId.firstWin));
      expect(result[MatchMomentId.firstWin]!.date, '2026-06-21');
    });

    test('already-unlocked moments are not re-emitted', () {
      final result = detectMoments(
        state: _state(
          history: [_playerWin(MoveChoice.scissors)],
          playerScore: 1,
        ),
        already: const <MatchMomentId>{MatchMomentId.firstWin},
        now: _now(),
      );
      expect(result.keys.contains(MatchMomentId.firstWin), isFalse);
    });

    test('rivalBreaker fires on [L, L, L, W]', () {
      final history = <RoundRecord>[
        _cpuWin(),
        _cpuWin(),
        _cpuWin(),
        _playerWin(MoveChoice.rock),
      ];
      final result = detectMoments(
        state: _state(history: history, playerScore: 1, cpuScore: 3),
        already: const <MatchMomentId>{},
        now: _now(),
      );
      expect(result.keys, contains(MatchMomentId.rivalBreaker));
    });

    test('rivalBreaker does NOT fire on [L, L, W] (only 2 losses)', () {
      final history = <RoundRecord>[
        _cpuWin(),
        _cpuWin(),
        _playerWin(MoveChoice.rock),
      ];
      final result = detectMoments(
        state: _state(history: history, playerScore: 1, cpuScore: 2),
        already: const <MatchMomentId>{},
        now: _now(),
      );
      expect(result.keys.contains(MatchMomentId.rivalBreaker), isFalse);
    });

    test('firstComeback fires on [L, L, W, W, W]', () {
      final history = <RoundRecord>[
        _cpuWin(),
        _cpuWin(),
        _playerWin(MoveChoice.rock),
        _playerWin(MoveChoice.paper),
        _playerWin(MoveChoice.scissors),
      ];
      final result = detectMoments(
        state: _state(history: history, playerScore: 3, cpuScore: 2),
        already: const <MatchMomentId>{},
        now: _now(),
      );
      expect(result.keys, contains(MatchMomentId.firstComeback));
    });

    test(
      'firstComeback does NOT fire when only 1 loss preceded the 3-win run',
      () {
        final history = <RoundRecord>[
          _playerWin(MoveChoice.rock),
          _cpuWin(),
          _playerWin(MoveChoice.rock),
          _playerWin(MoveChoice.paper),
          _playerWin(MoveChoice.scissors),
        ];
        final result = detectMoments(
          state: _state(history: history, playerScore: 4, cpuScore: 1),
          already: const <MatchMomentId>{},
          now: _now(),
        );
        expect(result.keys.contains(MatchMomentId.firstComeback), isFalse);
      },
    );

    test('unstoppableRound fires on [L, L, L, W, W, W, W, W]', () {
      final history = <RoundRecord>[
        _cpuWin(),
        _cpuWin(),
        _cpuWin(),
        _playerWin(MoveChoice.rock),
        _playerWin(MoveChoice.paper),
        _playerWin(MoveChoice.scissors),
        _playerWin(MoveChoice.rock),
        _playerWin(MoveChoice.paper),
      ];
      final result = detectMoments(
        state: _state(history: history, playerScore: 5, cpuScore: 3),
        already: const <MatchMomentId>{},
        now: _now(),
      );
      expect(result.keys, contains(MatchMomentId.unstoppableRound));
    });

    test(
      'triplePrediction fires when CPU plays the same move 3x and player counters all',
      () {
        final history = <RoundRecord>[
          _playerWin(MoveChoice.rock),
          _playerWin(MoveChoice.rock),
          _playerWin(MoveChoice.rock),
        ];
        final result = detectMoments(
          state: _state(history: history, playerScore: 3),
          already: const <MatchMomentId>{},
          now: _now(),
        );
        expect(result.keys, contains(MatchMomentId.triplePrediction));
        // Three different CPU moves are NOT the condition — make sure we
        // don't also trip counterMaster on the same set.
        expect(result.keys.contains(MatchMomentId.counterMaster), isFalse);
      },
    );

    test(
      'counterMaster fires when 3 different CPU moves are countered in a row',
      () {
        final history = <RoundRecord>[
          _playerWin(MoveChoice.rock),
          _playerWin(MoveChoice.paper),
          _playerWin(MoveChoice.scissors),
        ];
        final result = detectMoments(
          state: _state(history: history, playerScore: 3),
          already: const <MatchMomentId>{},
          now: _now(),
        );
        expect(result.keys, contains(MatchMomentId.counterMaster));
        expect(result.keys.contains(MatchMomentId.triplePrediction), isFalse);
      },
    );

    test(
      'turnaround fires on a player win while cpuScore - playerScore >= 2 post-resolve',
      () {
        // Pre-round gap was 3 (cpu 3, player 0). After the player win the gap is 2.
        final history = <RoundRecord>[
          _cpuWin(),
          _cpuWin(),
          _cpuWin(),
          _playerWin(MoveChoice.rock),
        ];
        final result = detectMoments(
          state: _state(history: history, playerScore: 1, cpuScore: 3),
          already: const <MatchMomentId>{},
          now: _now(),
        );
        expect(result.keys, contains(MatchMomentId.turnaround));
      },
    );

    test(
      'turnaround does NOT fire when the latest round is a CPU win',
      () {
        final history = <RoundRecord>[_cpuWin(), _cpuWin(), _cpuWin()];
        final result = detectMoments(
          state: _state(history: history, playerScore: 0, cpuScore: 3),
          already: const <MatchMomentId>{},
          now: _now(),
        );
        expect(result.keys.contains(MatchMomentId.turnaround), isFalse);
      },
    );
  });
}
