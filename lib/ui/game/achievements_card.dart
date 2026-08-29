import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rps_duel/domain/achievement.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/theme/tactile_theme.dart';

String achievementTitle(AppLocalizations l10n, AchievementId id) {
  return switch (id) {
    AchievementId.firstWin => l10n.achievementFirstWin,
    AchievementId.streak3 => l10n.achievementStreak3,
    AchievementId.scissorsSpecialist => l10n.achievementDailyChallenge,
    AchievementId.first10Rounds => l10n.achievementFirst10Rounds,
  };
}

class AchievementsCard extends StatelessWidget {
  const AchievementsCard({super.key, required this.unlocked});

  /// Map of unlocked achievements to the moment they were unlocked.
  /// `null` value = unlocked at unknown time (v1 → v2 migration).
  final Map<AchievementId, DateTime?> unlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final total = AchievementId.values.length;
    final unlockedIds = unlocked.keys.toSet();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/achievements', extra: unlocked),
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
                    l10n.achievementsCount(unlockedIds.length, total),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (unlockedIds.isEmpty)
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
                      if (unlockedIds.contains(id))
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
      ),
    );
  }
}
