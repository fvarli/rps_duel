import 'package:flutter/material.dart';

import 'package:rps_duel/domain/achievement.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/theme/tactile_theme.dart';

String achievementTitle(AppLocalizations l10n, AchievementId id) {
  return switch (id) {
    AchievementId.firstWin => l10n.achievementFirstWin,
    AchievementId.streak3 => l10n.achievementStreak3,
    AchievementId.scissorsSpecialist => l10n.achievementScissorsSpecialist,
    AchievementId.first10Rounds => l10n.achievementFirst10Rounds,
  };
}

class AchievementsCard extends StatelessWidget {
  const AchievementsCard({super.key, required this.unlocked});

  final Set<AchievementId> unlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final total = AchievementId.values.length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.workspace_premium,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.achievementsTitle,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Text(
                  l10n.achievementsCount(unlocked.length, total),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (unlocked.isEmpty)
              Text(
                l10n.achievementsNoneYet,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: <Widget>[
                  for (final id in AchievementId.values)
                    if (unlocked.contains(id))
                      Chip(
                        label: Text(achievementTitle(l10n, id)),
                        labelStyle: const TextStyle(
                          color: TactileColors.sage,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor:
                            const Color.fromRGBO(92, 125, 68, 0.12),
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                      ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
