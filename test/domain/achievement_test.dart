import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/domain/achievement.dart';
import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:rps_duel/domain/daily_challenge_kind.dart';
import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/duel_state.dart';
import 'package:rps_duel/domain/round_record.dart';

DuelState _stateWith({
  int playerScore = 0,
  int cpuScore = 0,
  int ties = 0,
  int roundCount = 0,
  int currentStreak = 0,
  int bestStreak = 0,
}) {
  return DuelState(
    phase: DuelPhase.idle,
    playerMove: null,
    cpuMove: null,
    outcome: null,
    playerScore: playerScore,
    cpuScore: cpuScore,
    ties: ties,
    roundCount: roundCount,
    history: const <RoundRecord>[],
    currentStreak: currentStreak,
    bestStreak: bestStreak,
  );
}

DailyChallenge _todayFresh() => DailyChallenge.initialFor(DateTime.now());

void main() {
  group('evaluateAchievements', () {
    test('First Win unlocks once playerScore >= 1', () {
      final result = evaluateAchievements(
        state: _stateWith(playerScore: 1),
        dailyChallenge: _todayFresh(),
        already: const <AchievementId>{},
      );
      expect(result, contains(AchievementId.firstWin));
    });

    test('Streak 3 unlocks once bestStreak >= 3', () {
      final result = evaluateAchievements(
        state: _stateWith(bestStreak: 3),
        dailyChallenge: _todayFresh(),
        already: const <AchievementId>{},
      );
      expect(result, contains(AchievementId.streak3));
    });

    test('Scissors Specialist unlocks when daily challenge completed', () {
      const completed = DailyChallenge(
        date: '2026-05-25',
        kind: DailyChallengeKind.winWithScissors,
        target: 3,
        progress: 3,
        completed: true,
      );
      final result = evaluateAchievements(
        state: _stateWith(),
        dailyChallenge: completed,
        already: const <AchievementId>{},
      );
      expect(result, contains(AchievementId.scissorsSpecialist));
    });

    test('First 10 Rounds unlocks once roundCount >= 10', () {
      final result = evaluateAchievements(
        state: _stateWith(roundCount: 10),
        dailyChallenge: _todayFresh(),
        already: const <AchievementId>{},
      );
      expect(result, contains(AchievementId.first10Rounds));
    });

    test('already-unlocked achievements survive re-evaluation on a zero state',
        () {
      final result = evaluateAchievements(
        state: _stateWith(),
        dailyChallenge: _todayFresh(),
        already: const <AchievementId>{
          AchievementId.firstWin,
          AchievementId.streak3,
        },
      );
      expect(
        result,
        containsAll(<AchievementId>{
          AchievementId.firstWin,
          AchievementId.streak3,
        }),
      );
    });
  });
}
