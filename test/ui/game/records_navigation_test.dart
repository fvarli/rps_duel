import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/app/locale_scope.dart';
import 'package:rps_duel/app/router.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/achievement_unlock_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    AchievementUnlockOverlay.debugReset();
    // `appRouter` is a top-level singleton, so its location survives
    // between tests. Reset to home or a later test starts on /records.
    appRouter.go('/');
  });

  Widget buildApp(ValueNotifier<Locale?> localeController) {
    return LocaleScope(
      controller: localeController,
      child: ValueListenableBuilder<Locale?>(
        valueListenable: localeController,
        builder: (ctx, current, _) => MaterialApp.router(
          locale: current,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: appRouter,
        ),
      ),
    );
  }

  testWidgets('the app bar action navigates to the Records screen',
      (tester) async {
    final localeController = ValueNotifier<Locale?>(null);
    await tester.pumpWidget(buildApp(localeController));
    await tester.pumpAndSettle();

    // Game screen visible. Identify the route by the Records screen's own
    // intro copy — "Records" itself also labels on-screen affordances.
    expect(find.text('A diary of memorable duels.'), findsNothing);
    expect(find.text('Round 0 · History: 0 rounds'), findsOneWidget);

    // The app bar entry is always on screen — no scrolling needed.
    await tester.tap(find.byIcon(Icons.auto_stories));
    await tester.pumpAndSettle();

    // Records screen reached. Empty state placeholders are visible.
    expect(find.text('A diary of memorable duels.'), findsOneWidget);
    expect(find.text('Moments'), findsOneWidget);
    expect(find.text('Move tendencies'), findsOneWidget);
    expect(find.text('Timeline'), findsOneWidget);
  });

  testWidgets('the summary line is no longer a hidden tap target',
      (tester) async {
    final localeController = ValueNotifier<Locale?>(null);
    await tester.pumpWidget(buildApp(localeController));
    await tester.pumpAndSettle();

    // Regression guard: this text used to be wrapped in a bare InkWell
    // with no icon, label or visual cue — an invisible control and an
    // accessibility trap. It is now plain status text; Records is reached
    // through the two labelled affordances instead.
    expect(find.text('Round 0 · History: 0 rounds'), findsOneWidget);
    await tester.tap(find.text('Round 0 · History: 0 rounds'));
    await tester.pumpAndSettle();

    expect(find.text('A diary of memorable duels.'), findsNothing);
    expect(find.text('Round 0 · History: 0 rounds'), findsOneWidget);
  });

  testWidgets('the history header exposes a labelled Records affordance',
      (tester) async {
    final localeController = ValueNotifier<Locale?>(null);
    await tester.pumpWidget(buildApp(localeController));
    await tester.pumpAndSettle();

    expect(find.text('Recent rounds'), findsOneWidget);
    expect(find.text('Records'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsAtLeastNWidgets(1));

    // The history header lives below the fold on a short viewport.
    await tester.ensureVisible(find.text('Records'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Records'));
    await tester.pumpAndSettle();

    expect(find.text('A diary of memorable duels.'), findsOneWidget);
    expect(find.text('Moments'), findsOneWidget);
  });

  testWidgets('both Records affordances are labelled for assistive tech',
      (tester) async {
    final handle = tester.ensureSemantics();
    final localeController = ValueNotifier<Locale?>(null);
    await tester.pumpWidget(buildApp(localeController));
    await tester.pumpAndSettle();

    // App bar action. Asserts `label`, not `tooltip`: a tooltip alone
    // leaves the semantics label empty, which is why the icon carries an
    // explicit semanticLabel.
    expect(
      tester.getSemantics(find.byIcon(Icons.auto_stories)),
      isSemantics(
        label: 'Records',
        isButton: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );

    // History header: announced as one labelled button rather than the
    // merged "Recent rounds Records" of its two Text children.
    final header = find.ancestor(
      of: find.text('Recent rounds'),
      matching: find.byType(Semantics),
    );
    expect(
      tester.getSemantics(header.first),
      isSemantics(label: 'Records', isButton: true),
    );

    handle.dispose();
  });
}
