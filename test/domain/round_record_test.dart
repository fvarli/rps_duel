import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';

void main() {
  test('RoundRecord JSON roundtrip preserves all fields', () {
    final original = RoundRecord(
      playerMove: MoveChoice.rock,
      cpuMove: MoveChoice.scissors,
      outcome: RoundOutcome.playerWin,
      timestamp: DateTime.utc(2026, 5, 24, 12, 30),
    );

    final restored = RoundRecord.fromJson(
      jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>,
    );

    expect(restored.playerMove, original.playerMove);
    expect(restored.cpuMove, original.cpuMove);
    expect(restored.outcome, original.outcome);
    expect(restored.timestamp, original.timestamp);
  });
}
