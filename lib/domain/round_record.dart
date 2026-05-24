import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';

class RoundRecord {
  const RoundRecord({
    required this.playerMove,
    required this.cpuMove,
    required this.outcome,
    required this.timestamp,
  });

  final MoveChoice playerMove;
  final MoveChoice cpuMove;
  final RoundOutcome outcome;
  final DateTime timestamp;
}
