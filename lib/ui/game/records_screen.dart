import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:rps_duel/domain/lifetime_stats.dart';
import 'package:rps_duel/domain/match_moment.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_record.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/history_row.dart';
import 'package:rps_duel/ui/theme/tactile_theme.dart';

/// A calm diary of memorable duels.
///
/// Three panels: narrative moments (one-time situations), move
/// tendencies (raw counts only — no judgment), and a chronological
/// timeline grouped by Today / Yesterday / Earlier.
class RecordsScreen extends StatelessWidget {
  const RecordsScreen({
    super.key,
    required this.history,
    required this.moments,
    required this.lifetime,
    DateTime? now,
  }) : _now = now;

  final List<RoundRecord> history;
  final Map<MatchMomentId, MatchMomentRecord> moments;
  final LifetimeStats lifetime;
  final DateTime? _now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final now = _now ?? DateTime.now();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recordsTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      l10n.recordsIntro,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _LifetimeCard(stats: lifetime),
                  const SizedBox(height: 16),
                  _MomentsCard(moments: moments, locale: locale),
                  const SizedBox(height: 16),
                  _TendenciesCard(history: history),
                  const SizedBox(height: 24),
                  _Timeline(history: history, now: now),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _momentTitle(AppLocalizations l10n, MatchMomentId id) {
  return switch (id) {
    MatchMomentId.firstWin => l10n.momentFirstWin,
    MatchMomentId.firstComeback => l10n.momentFirstComeback,
    MatchMomentId.rivalBreaker => l10n.momentRivalBreaker,
    MatchMomentId.unstoppableRound => l10n.momentUnstoppableRound,
    MatchMomentId.triplePrediction => l10n.momentTriplePrediction,
    MatchMomentId.counterMaster => l10n.momentCounterMaster,
    MatchMomentId.turnaround => l10n.momentTurnaround,
  };
}

String _momentNote(AppLocalizations l10n, MatchMomentId id) {
  return switch (id) {
    MatchMomentId.firstWin => l10n.momentFirstWinNote,
    MatchMomentId.firstComeback => l10n.momentFirstComebackNote,
    MatchMomentId.rivalBreaker => l10n.momentRivalBreakerNote,
    MatchMomentId.unstoppableRound => l10n.momentUnstoppableRoundNote,
    MatchMomentId.triplePrediction => l10n.momentTriplePredictionNote,
    MatchMomentId.counterMaster => l10n.momentCounterMasterNote,
    MatchMomentId.turnaround => l10n.momentTurnaroundNote,
  };
}

/// Public for the unlock-toast bridge.
String momentTitleFor(AppLocalizations l10n, MatchMomentId id) =>
    _momentTitle(l10n, id);

class _LifetimeCard extends StatelessWidget {
  const _LifetimeCard({required this.stats});

  final LifetimeStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(l10n.lifetimeSectionTitle, style: theme.textTheme.titleSmall),
            const SizedBox(height: 10),
            _LifetimeRow(label: l10n.lifetimeRounds, value: stats.totalRounds),
            const SizedBox(height: 6),
            _LifetimeRow(label: l10n.lifetimeWins, value: stats.totalWins),
            const SizedBox(height: 6),
            _LifetimeRow(label: l10n.lifetimeTies, value: stats.totalTies),
          ],
        ),
      ),
    );
  }
}

class _LifetimeRow extends StatelessWidget {
  const _LifetimeRow({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: TactileColors.inkSoft,
            ),
          ),
        ),
        Text(
          '$value',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _MomentsCard extends StatelessWidget {
  const _MomentsCard({required this.moments, required this.locale});

  final Map<MatchMomentId, MatchMomentRecord> moments;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final unlocked =
        MatchMomentId.values.where(moments.containsKey).toList(growable: false);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(l10n.momentsSectionTitle, style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            if (unlocked.isEmpty)
              Text(
                l10n.momentsEmptyState,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              for (var i = 0; i < unlocked.length; i++) ...<Widget>[
                _MomentRow(
                  id: unlocked[i],
                  record: moments[unlocked[i]]!,
                  locale: locale,
                ),
                if (i < unlocked.length - 1) const SizedBox(height: 12),
              ],
          ],
        ),
      ),
    );
  }
}

class _MomentRow extends StatelessWidget {
  const _MomentRow({
    required this.id,
    required this.record,
    required this.locale,
  });

  final MatchMomentId id;
  final MatchMomentRecord record;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final dateText = _formatRecordDate(record.date, locale);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(width: 4, color: TactileColors.sage),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  _momentTitle(l10n, id),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _momentNote(l10n, id),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: TactileColors.inkSoft,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dateText,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: TactileColors.inkMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TendenciesCard extends StatelessWidget {
  const _TendenciesCard({required this.history});

  final List<RoundRecord> history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final counts = <MoveChoice, int>{
      MoveChoice.rock: 0,
      MoveChoice.paper: 0,
      MoveChoice.scissors: 0,
    };
    for (final r in history) {
      counts[r.playerMove] = (counts[r.playerMove] ?? 0) + 1;
    }
    final maxCount = counts.values.fold<int>(0, (a, b) => a > b ? a : b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              l10n.tendenciesSectionTitle,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            for (final move in MoveChoice.values) ...<Widget>[
              _TendencyBar(
                label: labelForMove(l10n, move),
                emoji: emojiForMove(move),
                count: counts[move]!,
                maxCount: maxCount,
              ),
              if (move != MoveChoice.values.last) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _TendencyBar extends StatelessWidget {
  const _TendencyBar({
    required this.label,
    required this.emoji,
    required this.count,
    required this.maxCount,
  });

  final String label;
  final String emoji;
  final int count;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fill = maxCount == 0 ? 0.0 : count / maxCount;
    return Row(
      children: <Widget>[
        SizedBox(
          width: 26,
          child: Text(emoji, style: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 72,
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (ctx, c) {
              return Stack(
                children: <Widget>[
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: TactileColors.hairlineSoft,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: c.maxWidth * fill,
                    decoration: BoxDecoration(
                      color: TactileColors.sage,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 32,
          child: Text(
            '$count',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: TactileColors.inkSoft,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.history, required this.now});

  final List<RoundRecord> history;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final indexed = <_IndexedRound>[
      for (var i = 0; i < history.length; i++)
        _IndexedRound(roundNumber: i + 1, record: history[i]),
    ];
    final reversed = indexed.reversed.toList();

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todays = <_IndexedRound>[];
    final yesterdays = <_IndexedRound>[];
    final earlier = <_IndexedRound>[];
    for (final r in reversed) {
      final ts = r.record.timestamp;
      final day = DateTime(ts.year, ts.month, ts.day);
      if (day == today) {
        todays.add(r);
      } else if (day == yesterday) {
        yesterdays.add(r);
      } else {
        earlier.add(r);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(l10n.timelineSectionTitle, style: theme.textTheme.titleSmall),
        const SizedBox(height: 12),
        if (history.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.noRoundsYet,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else ...<Widget>[
          if (todays.isNotEmpty)
            _TimelineGroup(label: l10n.timelineGroupToday, rounds: todays),
          if (yesterdays.isNotEmpty)
            _TimelineGroup(
              label: l10n.timelineGroupYesterday,
              rounds: yesterdays,
            ),
          if (earlier.isNotEmpty)
            _TimelineGroup(label: l10n.timelineGroupEarlier, rounds: earlier),
        ],
      ],
    );
  }
}

class _TimelineGroup extends StatelessWidget {
  const _TimelineGroup({required this.label, required this.rounds});

  final String label;
  final List<_IndexedRound> rounds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: TactileColors.inkMuted,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        for (var i = 0; i < rounds.length; i++) ...<Widget>[
          HistoryRow(
            roundNumber: rounds[i].roundNumber,
            record: rounds[i].record,
          ),
          if (i < rounds.length - 1)
            Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant,
            ),
        ],
      ],
    );
  }
}

class _IndexedRound {
  const _IndexedRound({required this.roundNumber, required this.record});

  final int roundNumber;
  final RoundRecord record;
}

String _formatRecordDate(String dateString, Locale locale) {
  // dateString is `YYYY-MM-DD` (local). Parse leniently and render with
  // the locale-appropriate medium date format.
  try {
    final parts = dateString.split('-');
    final y = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final d = int.parse(parts[2]);
    return DateFormat.yMMMd(locale.toString()).format(DateTime(y, m, d));
  } catch (_) {
    return dateString;
  }
}
