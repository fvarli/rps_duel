import 'package:flutter/material.dart';

import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';

/// One row in a list of past rounds.
///
/// Extracted from the original `_HistoryRow` in game_screen.dart so the
/// same widget can be reused on the Records timeline. The visual shape
/// is unchanged: round-number badge, "{emoji} {move} vs {emoji} {move}"
/// text, outcome label colored by [_outcomeColor].
class HistoryRow extends StatelessWidget {
  const HistoryRow({
    super.key,
    required this.roundNumber,
    required this.record,
  });

  final int roundNumber;
  final RoundRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            alignment: Alignment.center,
            child: Text(
              '$roundNumber',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${emojiForMove(record.playerMove)} ${labelForMove(l10n, record.playerMove)}'
              '  vs  '
              '${emojiForMove(record.cpuMove)} ${labelForMove(l10n, record.cpuMove)}',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            outcomeText(l10n, record.outcome),
            style: theme.textTheme.bodySmall?.copyWith(
              color: outcomeColor(theme, record.outcome),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String emojiForMove(MoveChoice move) {
  return switch (move) {
    MoveChoice.rock => '🪨',
    MoveChoice.paper => '📄',
    MoveChoice.scissors => '✂️',
  };
}

String labelForMove(AppLocalizations l10n, MoveChoice move) {
  return switch (move) {
    MoveChoice.rock => l10n.moveRock,
    MoveChoice.paper => l10n.movePaper,
    MoveChoice.scissors => l10n.moveScissors,
  };
}

String outcomeText(AppLocalizations l10n, RoundOutcome outcome) {
  return switch (outcome) {
    RoundOutcome.playerWin => l10n.outcomePlayerWin,
    RoundOutcome.cpuWin => l10n.outcomeCpuWin,
    RoundOutcome.tie => l10n.outcomeTie,
  };
}

Color outcomeColor(ThemeData theme, RoundOutcome outcome) {
  return switch (outcome) {
    RoundOutcome.playerWin => theme.colorScheme.primary,
    RoundOutcome.cpuWin => theme.colorScheme.error,
    RoundOutcome.tie => theme.colorScheme.onSurfaceVariant,
  };
}
