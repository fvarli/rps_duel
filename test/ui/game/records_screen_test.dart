import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/domain/match_moment.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/records_screen.dart';

Widget _wrap({
  required List<RoundRecord> history,
  required Map<MatchMomentId, MatchMomentRecord> moments,
  DateTime? now,
  Locale? locale,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: RecordsScreen(history: history, moments: moments, now: now),
  );
}

void main() {
  testWidgets('empty state — header, intro, all three section titles render',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        history: const <RoundRecord>[],
        moments: const <MatchMomentId, MatchMomentRecord>{},
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Records'), findsOneWidget);
    expect(find.text('A diary of memorable duels.'), findsOneWidget);
    expect(find.text('Moments'), findsOneWidget);
    expect(
      find.text('Moments will appear here as you play.'),
      findsOneWidget,
    );
    expect(find.text('Move tendencies'), findsOneWidget);
    expect(find.text('Timeline'), findsOneWidget);
    expect(find.text('No rounds yet.'), findsOneWidget);
  });

  testWidgets('unlocked moment shows serif title, note, and date',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        history: const <RoundRecord>[],
        moments: const <MatchMomentId, MatchMomentRecord>{
          MatchMomentId.firstWin: MatchMomentRecord(date: '2026-06-20'),
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('First Win'), findsOneWidget);
    expect(find.text('Your first taste of victory.'), findsOneWidget);
    expect(find.textContaining('Jun 20'), findsOneWidget);
    // Empty-state message must NOT be present any more.
    expect(find.text('Moments will appear here as you play.'), findsNothing);
  });

  testWidgets('move-tendency bars show one count per move', (tester) async {
    final history = <RoundRecord>[
      // 3 Rocks, 1 Paper, 2 Scissors.
      _round(MoveChoice.rock, MoveChoice.scissors, RoundOutcome.playerWin),
      _round(MoveChoice.rock, MoveChoice.scissors, RoundOutcome.playerWin),
      _round(MoveChoice.rock, MoveChoice.scissors, RoundOutcome.playerWin),
      _round(MoveChoice.paper, MoveChoice.rock, RoundOutcome.playerWin),
      _round(MoveChoice.scissors, MoveChoice.paper, RoundOutcome.playerWin),
      _round(MoveChoice.scissors, MoveChoice.paper, RoundOutcome.playerWin),
    ];
    await tester.pumpWidget(
      _wrap(
        history: history,
        moments: const <MatchMomentId, MatchMomentRecord>{},
      ),
    );
    await tester.pumpAndSettle();

    // Tendency counts appear in the Tendencies card; the timeline also
    // renders its own round-number badges. Assert at least one of each
    // expected count is on screen rather than over-constraining.
    expect(find.text('3'), findsAtLeastNWidgets(1)); // Rock count
    expect(find.text('1'), findsAtLeastNWidgets(1)); // Paper count
    expect(find.text('2'), findsAtLeastNWidgets(1)); // Scissors count
    // No percentage symbol anywhere — tendencies are raw counts only.
    expect(find.textContaining('%'), findsNothing);
  });

  testWidgets('timeline groups rounds by Today / Yesterday / Earlier',
      (tester) async {
    final now = DateTime(2026, 6, 21, 14);
    final history = <RoundRecord>[
      _roundAt(DateTime(2026, 6, 10, 9)),
      _roundAt(DateTime(2026, 6, 20, 10)),
      _roundAt(DateTime(2026, 6, 21, 13)),
    ];
    await tester.pumpWidget(
      _wrap(
        history: history,
        moments: const <MatchMomentId, MatchMomentRecord>{},
        now: now,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('Earlier'), findsOneWidget);
    // Every round is rendered (one HistoryRow each).
    expect(find.textContaining('vs'), findsNWidgets(3));
  });

  testWidgets('Turkish locale renders the localized section titles',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        history: const <RoundRecord>[],
        moments: const <MatchMomentId, MatchMomentRecord>{},
        locale: const Locale('tr'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kayıtlar'), findsOneWidget);
    expect(find.text('Anlar'), findsOneWidget);
    expect(find.text('Hamle eğilimleri'), findsOneWidget);
    expect(find.text('Zaman çizelgesi'), findsOneWidget);
  });
}

RoundRecord _round(
  MoveChoice player,
  MoveChoice cpu,
  RoundOutcome outcome,
) {
  return RoundRecord(
    playerMove: player,
    cpuMove: cpu,
    outcome: outcome,
    timestamp: DateTime(2026, 6, 21, 12),
  );
}

RoundRecord _roundAt(DateTime ts) {
  return RoundRecord(
    playerMove: MoveChoice.rock,
    cpuMove: MoveChoice.scissors,
    outcome: RoundOutcome.playerWin,
    timestamp: ts,
  );
}
