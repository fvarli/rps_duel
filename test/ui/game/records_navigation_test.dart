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
  });

  testWidgets('tapping the summary line navigates to the Records screen',
      (tester) async {
    final localeController = ValueNotifier<Locale?>(null);
    await tester.pumpWidget(
      LocaleScope(
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
      ),
    );
    await tester.pumpAndSettle();

    // Game screen visible — summary line shows "Round 0 · History: 0 rounds".
    expect(find.text('Records'), findsNothing);
    expect(find.text('Round 0 · History: 0 rounds'), findsOneWidget);

    await tester.tap(find.text('Round 0 · History: 0 rounds'));
    await tester.pumpAndSettle();

    // Records screen reached. Empty state placeholders are visible.
    expect(find.text('Records'), findsOneWidget);
    expect(find.text('A diary of memorable duels.'), findsOneWidget);
    expect(find.text('Moments'), findsOneWidget);
    expect(find.text('Move tendencies'), findsOneWidget);
    expect(find.text('Timeline'), findsOneWidget);
  });
}
