import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/domain/cpu_difficulty.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/settings_sheet.dart';

Widget _harness({
  required bool initialSound,
  required ValueChanged<bool> onChanged,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Builder(
        builder: (ctx) => Center(
          child: TextButton(
            onPressed: () {
              showSettingsSheet(
                ctx,
                currentDifficulty: CpuDifficulty.normal,
                soundEnabled: initialSound,
                onSoundChanged: onChanged,
                onDifficulty: () {},
                onLanguage: () {},
                onResetData: () {},
                onAbout: () {},
              );
            },
            child: const Text('open settings'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('settings sheet shows a Sound row reflecting current state',
      (tester) async {
    await tester.pumpWidget(
      _harness(initialSound: true, onChanged: (_) {}),
    );
    await tester.tap(find.text('open settings'));
    await tester.pumpAndSettle();

    expect(find.text('Sound'), findsOneWidget);
    // The switch is on when sound is enabled.
    final initialSwitch = tester.widget<Switch>(find.byType(Switch));
    expect(initialSwitch.value, isTrue);
  });

  testWidgets('toggling the Sound row fires onSoundChanged with the new value',
      (tester) async {
    final calls = <bool>[];
    await tester.pumpWidget(_harness(initialSound: true, onChanged: calls.add));
    await tester.tap(find.text('open settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(calls, <bool>[false]);
    // The switch in the sheet has flipped without closing the sheet.
    final flippedSwitch = tester.widget<Switch>(find.byType(Switch));
    expect(flippedSwitch.value, isFalse);
    // The other rows remain present — the toggle does not dismiss the sheet.
    expect(find.text('Reset data'), findsOneWidget);
  });
}
