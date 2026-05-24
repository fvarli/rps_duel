import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';

class DuelState {
  DuelState({
    required this.phase,
    required this.playerMove,
    required this.cpuMove,
    required this.outcome,
    required this.playerScore,
    required this.cpuScore,
    required this.ties,
    required this.roundCount,
    required List<RoundRecord> history,
  }) : history = List<RoundRecord>.unmodifiable(history);

  factory DuelState.initial() => DuelState(
        phase: DuelPhase.idle,
        playerMove: null,
        cpuMove: null,
        outcome: null,
        playerScore: 0,
        cpuScore: 0,
        ties: 0,
        roundCount: 0,
        history: const <RoundRecord>[],
      );

  final DuelPhase phase;
  final MoveChoice? playerMove;
  final MoveChoice? cpuMove;
  final RoundOutcome? outcome;
  final int playerScore;
  final int cpuScore;
  final int ties;
  final int roundCount;
  final List<RoundRecord> history;
}
