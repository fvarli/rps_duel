import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/app/locale_scope.dart';
import 'package:rps_duel/app/router.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('tapping the achievements card navigates to the collection',
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

    // Game screen visible; collection not.
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Collection'), findsNothing);

    await tester.tap(find.text('Achievements'));
    await tester.pumpAndSettle();

    // Collection screen reached. Empty-state placeholders are visible.
    expect(find.text('Collection'), findsOneWidget);
    expect(find.text('EXHIBIT I'), findsOneWidget);
    expect(find.text('EXHIBIT IV'), findsOneWidget);
  });
}
