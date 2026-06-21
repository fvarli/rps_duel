import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:rps_duel/domain/daily_challenge_kind.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/daily_challenge_card.dart';

Widget _wrap(DailyChallenge c, {Locale? locale}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: DailyChallengeCard(challenge: c)),
  );
}

void main() {
  testWidgets('winRounds kind renders the rotation-aware copy + target',
      (tester) async {
    const c = DailyChallenge(
      date: '2026-06-21',
      kind: DailyChallengeKind.winRounds,
      target: 3,
      progress: 1,
      completed: false,
    );
    await tester.pumpWidget(_wrap(c));
    await tester.pumpAndSettle();

    expect(find.text('Daily Challenge'), findsOneWidget);
    expect(find.text('Win 3 rounds today'), findsOneWidget);
    expect(find.text('1/3'), findsOneWidget);
  });

  testWidgets('winWithRock kind renders the per-move copy', (tester) async {
    const c = DailyChallenge(
      date: '2026-06-22',
      kind: DailyChallengeKind.winWithRock,
      target: 2,
      progress: 0,
      completed: false,
    );
    await tester.pumpWidget(_wrap(c));
    await tester.pumpAndSettle();

    expect(find.text('Win 2 rounds with Rock'), findsOneWidget);
    expect(find.text('0/2'), findsOneWidget);
  });

  testWidgets('winStreak copy reads naturally for a 3-round streak',
      (tester) async {
    const c = DailyChallenge(
      date: '2026-06-23',
      kind: DailyChallengeKind.winStreak,
      target: 3,
      progress: 2,
      completed: false,
    );
    await tester.pumpWidget(_wrap(c));
    await tester.pumpAndSettle();

    expect(find.text('Reach a 3-round winning streak'), findsOneWidget);
    expect(find.text('2/3'), findsOneWidget);
  });

  testWidgets('completed challenge replaces progress with completed label',
      (tester) async {
    const c = DailyChallenge(
      date: '2026-06-23',
      kind: DailyChallengeKind.getTies,
      target: 2,
      progress: 2,
      completed: true,
    );
    await tester.pumpWidget(_wrap(c));
    await tester.pumpAndSettle();

    expect(find.text('Tie 2 rounds today'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('2/2'), findsNothing);
  });

  testWidgets('Turkish locale renders kind-specific Turkish copy',
      (tester) async {
    const c = DailyChallenge(
      date: '2026-06-21',
      kind: DailyChallengeKind.playRounds,
      target: 5,
      progress: 1,
      completed: false,
    );
    await tester.pumpWidget(_wrap(c, locale: const Locale('tr')));
    await tester.pumpAndSettle();

    expect(find.text('Günlük Görev'), findsOneWidget);
    expect(find.text('Bugün 5 el oyna'), findsOneWidget);
  });
}
