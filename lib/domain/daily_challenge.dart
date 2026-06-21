import 'dart:math' as math;

import 'package:rps_duel/domain/daily_challenge_kind.dart';
import 'package:rps_duel/domain/duel_state.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';

/// Today's challenge for the player. Date is the local calendar day; kind
/// is selected deterministically by [dailyChallengeKindFor] so the
/// rotation is consistent regardless of when the player opens the app.
class DailyChallenge {
  const DailyChallenge({
    required this.date,
    required this.kind,
    required this.target,
    required this.progress,
    required this.completed,
  });

  /// Build today's challenge from the local clock. The kind is chosen by
  /// the rotation; the target follows from the kind.
  factory DailyChallenge.initialFor(DateTime now) {
    final date = _formatLocalDate(now);
    final kind = dailyChallengeKindFor(date);
    return DailyChallenge(
      date: date,
      kind: kind,
      target: targetFor(kind),
      progress: 0,
      completed: false,
    );
  }

  /// Deserialize. Backward-compatible with the pre-rotation schema:
  /// any persisted record missing `kind` is treated as the legacy
  /// "win N with scissors" challenge so in-flight progress is preserved.
  factory DailyChallenge.fromJson(Map<String, dynamic> map) {
    final kindName = map['kind'] as String?;
    DailyChallengeKind kind;
    if (kindName == null) {
      kind = DailyChallengeKind.winWithScissors;
    } else {
      try {
        kind = DailyChallengeKind.values.byName(kindName);
      } catch (_) {
        // Unknown kind from a future build — fall back to the calm day.
        kind = DailyChallengeKind.playRounds;
      }
    }
    final target = (map['target'] as int?) ?? targetFor(kind);
    return DailyChallenge(
      date: map['date'] as String,
      kind: kind,
      target: target,
      progress: map['progress'] as int,
      completed: map['completed'] as bool,
    );
  }

  final String date;
  final DailyChallengeKind kind;
  final int target;
  final int progress;
  final bool completed;

  bool isToday(DateTime now) => date == _formatLocalDate(now);

  /// Advance the per-kind progress counter after a round resolves.
  ///
  /// [state] is the post-resolve duel state; the streak kind reads
  /// [DuelState.currentStreak] so we don't duplicate bookkeeping.
  DailyChallenge advanceFor({
    required MoveChoice playerMove,
    required RoundOutcome outcome,
    required DuelState state,
  }) {
    if (completed) return this;
    final next = _nextProgress(playerMove, outcome, state);
    if (next == progress) return this;
    return DailyChallenge(
      date: date,
      kind: kind,
      target: target,
      progress: next,
      completed: next >= target,
    );
  }

  int _nextProgress(
    MoveChoice playerMove,
    RoundOutcome outcome,
    DuelState state,
  ) {
    final win = outcome == RoundOutcome.playerWin;
    int bumpIf(bool cond) => cond ? (progress + 1).clamp(0, target) : progress;
    return switch (kind) {
      DailyChallengeKind.winRounds => bumpIf(win),
      DailyChallengeKind.winWithRock =>
        bumpIf(win && playerMove == MoveChoice.rock),
      DailyChallengeKind.winWithPaper =>
        bumpIf(win && playerMove == MoveChoice.paper),
      DailyChallengeKind.winWithScissors =>
        bumpIf(win && playerMove == MoveChoice.scissors),
      DailyChallengeKind.getTies => bumpIf(outcome == RoundOutcome.tie),
      // Best in-day streak. Monotonic: a loss reverts the player's live
      // streak to 0 but does not undo today's recorded best.
      DailyChallengeKind.winStreak => win
          ? math.max(progress, state.currentStreak.clamp(0, target))
          : progress,
      DailyChallengeKind.playRounds => (progress + 1).clamp(0, target),
    };
  }

  Map<String, Object?> toJson() => <String, Object?>{
        'date': date,
        'kind': kind.name,
        'target': target,
        'progress': progress,
        'completed': completed,
      };
}

String _formatLocalDate(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}
