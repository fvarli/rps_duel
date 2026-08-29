import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:rps_duel/domain/achievement.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/achievements_card.dart' show achievementTitle;
import 'package:rps_duel/ui/theme/tactile_theme.dart';

/// The "Collection" — a museum-style view of every achievement.
///
/// Each achievement is a permanent exhibit (I..IV) so the shape of the
/// collection is visible from day one. Unlocked exhibits show the artifact
/// name (serif italic, echoing the duel reveal), a one-line curator note,
/// and the date entered the collection. Locked exhibits show only their
/// exhibit number — no progress bars, no hints, no checklist language.
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key, required this.unlocked});

  /// Map of unlocked achievements to the moment they entered the collection.
  /// `null` value = unlocked at unknown time (migrated from schema v1).
  final Map<AchievementId, DateTime?> unlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.collectionTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      l10n.collectionIntro,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 28),
                  for (var i = 0;
                      i < AchievementId.values.length;
                      i++) ...<Widget>[
                    _ArtifactCard(
                      id: AchievementId.values[i],
                      exhibitNumber: i + 1,
                      unlockedAt: unlocked[AchievementId.values[i]],
                      isUnlocked: unlocked.containsKey(AchievementId.values[i]),
                      locale: locale,
                    ),
                    if (i < AchievementId.values.length - 1)
                      const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _achievementNote(AppLocalizations l10n, AchievementId id) {
  return switch (id) {
    AchievementId.firstWin => l10n.achievementFirstWinNote,
    AchievementId.streak3 => l10n.achievementStreak3Note,
    AchievementId.scissorsSpecialist => l10n.achievementDailyChallengeNote,
    AchievementId.first10Rounds => l10n.achievementFirst10RoundsNote,
  };
}

String _romanNumeral(int n) {
  // Domain is tiny (1..AchievementId.values.length). Hand-table beats arithmetic.
  return switch (n) {
    1 => 'I',
    2 => 'II',
    3 => 'III',
    4 => 'IV',
    5 => 'V',
    6 => 'VI',
    7 => 'VII',
    8 => 'VIII',
    _ => n.toString(),
  };
}

class _ArtifactCard extends StatelessWidget {
  const _ArtifactCard({
    required this.id,
    required this.exhibitNumber,
    required this.unlockedAt,
    required this.isUnlocked,
    required this.locale,
  });

  final AchievementId id;
  final int exhibitNumber;
  final DateTime? unlockedAt;
  final bool isUnlocked;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final exhibitLabel =
        '${l10n.exhibitPrefix} ${_romanNumeral(exhibitNumber)}';

    final decoration = BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color:
            isUnlocked ? theme.colorScheme.outline : TactileColors.hairlineSoft,
      ),
      boxShadow: isUnlocked
          ? const <BoxShadow>[
              BoxShadow(
                color: TactileColors.shadowInk10,
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ]
          : null,
    );

    return Container(
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Sage accent strip — only on unlocked exhibits.
              if (isUnlocked) Container(width: 4, color: TactileColors.sage),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                  child: isUnlocked
                      ? _UnlockedBody(
                          exhibitLabel: exhibitLabel,
                          title: achievementTitle(l10n, id),
                          note: _achievementNote(l10n, id),
                          unlockedAt: unlockedAt,
                          locale: locale,
                          l10n: l10n,
                        )
                      : _LockedBody(exhibitLabel: exhibitLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnlockedBody extends StatelessWidget {
  const _UnlockedBody({
    required this.exhibitLabel,
    required this.title,
    required this.note,
    required this.unlockedAt,
    required this.locale,
    required this.l10n,
  });

  final String exhibitLabel;
  final String title;
  final String note;
  final DateTime? unlockedAt;
  final Locale locale;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlockText = unlockedAt == null
        ? l10n.unlockedLabel
        : l10n.unlockedOnLabel(
            DateFormat.yMMMd(locale.toString()).format(unlockedAt!),
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          exhibitLabel,
          style: const TextStyle(
            color: TactileColors.sage,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontFamily: 'serif',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          note,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: TactileColors.inkSoft,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          unlockText,
          style: theme.textTheme.labelSmall?.copyWith(
            color: TactileColors.inkMuted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _LockedBody extends StatelessWidget {
  const _LockedBody({required this.exhibitLabel});

  final String exhibitLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 26),
      child: Center(
        child: Text(
          exhibitLabel,
          style: const TextStyle(
            color: TactileColors.inkFaint,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.4,
          ),
        ),
      ),
    );
  }
}
