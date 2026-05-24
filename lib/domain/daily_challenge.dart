import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';

class DailyChallenge {
  const DailyChallenge({
    required this.date,
    required this.progress,
    required this.completed,
  });

  static const int target = 3;

  factory DailyChallenge.initialFor(DateTime now) => DailyChallenge(
        date: _formatLocalDate(now),
        progress: 0,
        completed: false,
      );

  factory DailyChallenge.fromJson(Map<String, dynamic> map) => DailyChallenge(
        date: map['date'] as String,
        progress: map['progress'] as int,
        completed: map['completed'] as bool,
      );

  final String date;
  final int progress;
  final bool completed;

  bool isToday(DateTime now) => date == _formatLocalDate(now);

  DailyChallenge advanceFor(MoveChoice playerMove, RoundOutcome outcome) {
    if (outcome != RoundOutcome.playerWin) return this;
    if (playerMove != MoveChoice.scissors) return this;
    if (completed) return this;
    final next = (progress + 1).clamp(0, target);
    return DailyChallenge(
      date: date,
      progress: next,
      completed: next >= target,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
        'date': date,
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
