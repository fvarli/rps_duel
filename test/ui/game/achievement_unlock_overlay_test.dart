import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/domain/achievement.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/achievement_unlock_overlay.dart';

Widget _harness({required void Function(BuildContext ctx) onPressed}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Builder(
        builder: (ctx) => Center(
          child: TextButton(
            onPressed: () => onPressed(ctx),
            child: const Text('go'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  setUp(AchievementUnlockOverlay.debugReset);

  testWidgets('multiple unlocks queued sequentially in submission order',
      (tester) async {
    await tester.pumpWidget(
      _harness(
        onPressed: (ctx) {
          // Submission order is the queue's contract. The game screen sorts
          // newly unlocked IDs by enum index before enqueueing, so the toast
          // sequence is deterministic for callers that need it.
          AchievementUnlockOverlay.enqueue(ctx, AchievementId.firstWin);
          AchievementUnlockOverlay.enqueue(ctx, AchievementId.streak3);
        },
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    // First toast visible. Second has not started.
    expect(find.text('ACHIEVEMENT UNLOCKED'), findsOneWidget);
    expect(find.text('First Win'), findsOneWidget);
    expect(find.text('Streak 3'), findsNothing);

    // Drain the first toast (hold + exit + dismissed callback chain).
    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pumpAndSettle();

    // Second toast now visible.
    expect(find.text('ACHIEVEMENT UNLOCKED'), findsOneWidget);
    expect(find.text('Streak 3'), findsOneWidget);
    expect(find.text('First Win'), findsNothing);

    // Drain the second toast.
    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pumpAndSettle();

    expect(find.text('ACHIEVEMENT UNLOCKED'), findsNothing);
    expect(find.text('Streak 3'), findsNothing);
  });
}
