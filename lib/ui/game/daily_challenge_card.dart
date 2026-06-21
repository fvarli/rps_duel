import 'package:flutter/material.dart';

import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:rps_duel/domain/daily_challenge_kind.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/theme/tactile_theme.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key, required this.challenge});

  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            Icon(
              challenge.completed ? Icons.emoji_events : Icons.flag,
              color: challenge.completed
                  ? TactileColors.sage
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    l10n.dailyChallengeTitle,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _descriptionFor(l10n, challenge),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              challenge.completed
                  ? l10n.dailyChallengeCompleted
                  : '${challenge.progress}/${challenge.target}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: challenge.completed ? TactileColors.sage : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _descriptionFor(AppLocalizations l10n, DailyChallenge c) {
  return switch (c.kind) {
    DailyChallengeKind.winRounds => l10n.dailyChallengeWinRounds(c.target),
    DailyChallengeKind.winWithRock => l10n.dailyChallengeWinRock(c.target),
    DailyChallengeKind.winWithPaper => l10n.dailyChallengeWinPaper(c.target),
    DailyChallengeKind.winWithScissors =>
      l10n.dailyChallengeWinScissors(c.target),
    DailyChallengeKind.getTies => l10n.dailyChallengeGetTies(c.target),
    DailyChallengeKind.winStreak => l10n.dailyChallengeWinStreak(c.target),
    DailyChallengeKind.playRounds => l10n.dailyChallengePlayRounds(c.target),
  };
}
