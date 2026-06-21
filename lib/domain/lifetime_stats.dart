import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';

/// Three quiet, monotonically-increasing facts about how much the player
/// has played: total rounds, total wins, total ties. Survives Reset Game,
/// survives the history soft cap. Never decreases.
///
/// Deliberately narrow: no percentages, no streaks, no rankings, no "best
/// move." The lifetime card on the Records screen renders these as raw
/// numbers and nothing else.
class LifetimeStats {
  const LifetimeStats({
    required this.totalRounds,
    required this.totalWins,
    required this.totalTies,
  });

  factory LifetimeStats.zero() => const LifetimeStats(
        totalRounds: 0,
        totalWins: 0,
        totalTies: 0,
      );

  factory LifetimeStats.fromJson(Map<String, dynamic> map) => LifetimeStats(
        totalRounds: (map['totalRounds'] as int?) ?? 0,
        totalWins: (map['totalWins'] as int?) ?? 0,
        totalTies: (map['totalTies'] as int?) ?? 0,
      );

  final int totalRounds;
  final int totalWins;
  final int totalTies;

  Map<String, Object?> toJson() => <String, Object?>{
        'totalRounds': totalRounds,
        'totalWins': totalWins,
        'totalTies': totalTies,
      };

  LifetimeStats copyWith({int? totalRounds, int? totalWins, int? totalTies}) {
    return LifetimeStats(
      totalRounds: totalRounds ?? this.totalRounds,
      totalWins: totalWins ?? this.totalWins,
      totalTies: totalTies ?? this.totalTies,
    );
  }
}

/// Pure: given the previous lifetime totals and the round that just
/// resolved, return the new totals. One round, one increment.
LifetimeStats incrementLifetimeFor(LifetimeStats prev, RoundRecord record) {
  return LifetimeStats(
    totalRounds: prev.totalRounds + 1,
    totalWins:
        prev.totalWins + (record.outcome == RoundOutcome.playerWin ? 1 : 0),
    totalTies: prev.totalTies + (record.outcome == RoundOutcome.tie ? 1 : 0),
  );
}
