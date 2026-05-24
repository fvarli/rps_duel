import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';

class RoundRecord {
  const RoundRecord({
    required this.playerMove,
    required this.cpuMove,
    required this.outcome,
    required this.timestamp,
  });

  factory RoundRecord.fromJson(Map<String, dynamic> map) => RoundRecord(
        playerMove: MoveChoice.values.byName(map['playerMove'] as String),
        cpuMove: MoveChoice.values.byName(map['cpuMove'] as String),
        outcome: RoundOutcome.values.byName(map['outcome'] as String),
        timestamp: DateTime.parse(map['timestamp'] as String),
      );

  final MoveChoice playerMove;
  final MoveChoice cpuMove;
  final RoundOutcome outcome;
  final DateTime timestamp;

  Map<String, Object?> toJson() => <String, Object?>{
        'playerMove': playerMove.name,
        'cpuMove': cpuMove.name,
        'outcome': outcome.name,
        'timestamp': timestamp.toIso8601String(),
      };
}
