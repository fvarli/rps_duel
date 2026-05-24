import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:rps_duel/domain/duel_state.dart';

enum AchievementId {
  firstWin,
  streak3,
  scissorsSpecialist,
  first10Rounds,
}

Set<AchievementId> evaluateAchievements({
  required DuelState state,
  required DailyChallenge dailyChallenge,
  required Set<AchievementId> already,
}) {
  final next = <AchievementId>{...already};
  if (state.playerScore >= 1) next.add(AchievementId.firstWin);
  if (state.bestStreak >= 3) next.add(AchievementId.streak3);
  if (dailyChallenge.completed) next.add(AchievementId.scissorsSpecialist);
  if (state.roundCount >= 10) next.add(AchievementId.first10Rounds);
  return next;
}
