import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/domain/achievement.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/achievements_screen.dart';

Widget _wrap(Map<AchievementId, DateTime?> unlocked, {Locale? locale}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: AchievementsScreen(unlocked: unlocked),
  );
}

void main() {
  testWidgets('with nothing unlocked renders four exhibit placeholders',
      (tester) async {
    await tester.pumpWidget(_wrap(const <AchievementId, DateTime?>{}));
    await tester.pumpAndSettle();

    expect(find.text('Collection'), findsOneWidget);
    expect(find.text('Each duel adds to this record.'), findsOneWidget);

    // Roman numeral exhibit placeholders for all four artifacts.
    expect(find.text('EXHIBIT I'), findsOneWidget);
    expect(find.text('EXHIBIT II'), findsOneWidget);
    expect(find.text('EXHIBIT III'), findsOneWidget);
    expect(find.text('EXHIBIT IV'), findsOneWidget);

    // No artifact titles, notes, or unlocked labels appear yet.
    expect(find.text('First Win'), findsNothing);
    expect(find.text('Your first taste of victory.'), findsNothing);
    expect(find.text('unlocked'), findsNothing);
  });

  testWidgets(
      'a single unlocked achievement reveals title, note, and dated label',
      (tester) async {
    final unlockedAt = DateTime.utc(2026, 6, 20);
    await tester.pumpWidget(
      _wrap(<AchievementId, DateTime?>{
        AchievementId.firstWin: unlockedAt,
      }),
    );
    await tester.pumpAndSettle();

    // EXHIBIT I now serves the artifact; II/III/IV remain placeholders.
    expect(find.text('EXHIBIT I'), findsOneWidget);
    expect(find.text('First Win'), findsOneWidget);
    expect(find.text('Your first taste of victory.'), findsOneWidget);
    // Date appears in the unlocked-on label.
    expect(find.textContaining('Jun 20, 2026'), findsOneWidget);

    expect(find.text('EXHIBIT II'), findsOneWidget);
    expect(find.text('EXHIBIT III'), findsOneWidget);
    expect(find.text('EXHIBIT IV'), findsOneWidget);
    expect(find.text('Streak 3'), findsNothing);
  });

  testWidgets('a migrated (null-timestamp) unlock shows plain "unlocked" label',
      (tester) async {
    await tester.pumpWidget(
      _wrap(const <AchievementId, DateTime?>{
        AchievementId.streak3: null,
      }),
    );
    await tester.pumpAndSettle();

    expect(find.text('Streak 3'), findsOneWidget);
    expect(find.text('unlocked'), findsOneWidget);
    expect(find.textContaining('2026'), findsNothing);
  });

  testWidgets('renders Turkish strings under tr locale', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const <AchievementId, DateTime?>{},
        locale: const Locale('tr'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Koleksiyon'), findsOneWidget);
    expect(find.text('Her düello bu kayda eklenir.'), findsOneWidget);
    expect(find.text('ESER I'), findsOneWidget);
    expect(find.text('ESER IV'), findsOneWidget);
  });
}
