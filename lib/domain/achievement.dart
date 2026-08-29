import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:rps_duel/domain/duel_state.dart';

enum AchievementId {
  firstWin,
  streak3,

  /// Awarded for completing any Daily Challenge.
  ///
  /// The name is historical and deliberately NOT renamed: it is the
  /// persisted JSON key in `rps_duel.achievements.v2`, so changing it
  /// would orphan every unlock already on a player's device. When this
  /// shipped there was a single challenge ("win 3 with Scissors"); the
  /// rotation added six more kinds without touching the trigger. The
  /// user-facing strings were corrected to match the real condition —
  /// see `achievementDailyChallenge` in the ARB files.
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
