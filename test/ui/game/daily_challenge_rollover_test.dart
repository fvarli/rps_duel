import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/app/locale_scope.dart';
import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:rps_duel/domain/daily_challenge_kind.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/achievement_unlock_overlay.dart';
import 'package:rps_duel/ui/game/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Regression coverage for the midnight-rollover defect.
///
/// `DailyChallenge.isToday` used to be consulted only in the screen's
/// load path, which runs from `initState`. An app left warm across
/// midnight therefore kept serving yesterday's challenge indefinitely,
/// and the progress it accumulated was written under yesterday's date —
/// then silently discarded on the next cold start. `GameScreen` now
/// re-checks on `AppLifecycleState.resumed`.
const String _v2Key = 'rps_duel.daily_challenge.v2';

String _formatLocalDate(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

/// A stale record: yesterday's date, with progress already banked.
String _staleChallengeJson(DateTime now) {
  final yesterday = now.subtract(const Duration(days: 1));
  return json.encode(<String, Object?>{
    'date': _formatLocalDate(yesterday),
    'kind': DailyChallengeKind.winWithScissors.name,
    'target': 3,
    'progress': 2,
    'completed': false,
  });
}

Widget _buildApp() {
  final controller = ValueNotifier<Locale?>(null);
  return LocaleScope(
    controller: controller,
    child: ValueListenableBuilder<Locale?>(
      valueListenable: controller,
      builder: (ctx, current, _) => MaterialApp(
        locale: current,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const GameScreen(cpuThinkingDelay: Duration.zero),
      ),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    AchievementUnlockOverlay.debugReset();
  });

  testWidgets('a stale challenge is replaced with today\'s on resume',
      (tester) async {
    final now = DateTime.now();
    final todaysKind = dailyChallengeKindFor(_formatLocalDate(now));
    final todaysTarget = targetFor(todaysKind);

    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    // Simulate the app having been warm since before midnight: the
    // persisted record now belongs to yesterday while the screen is
    // already mounted. `getInstance()` hands back the same singleton the
    // screen's storage is holding, so this mutates the store it reads.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_v2Key, _staleChallengeJson(now));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    // The card shows a fresh challenge for today: zero progress against
    // today's rotation target, not yesterday's banked 2/3.
    expect(find.text('0/$todaysTarget'), findsOneWidget);
    expect(find.text('2/3'), findsNothing);

    // ...and the fresh record was persisted under today's date.
    final written =
        json.decode(prefs.getString(_v2Key)!) as Map<String, dynamic>;
    expect(written['date'], _formatLocalDate(now));
    expect(written['kind'], todaysKind.name);
    expect(written['progress'], 0);
  });

  testWidgets('a resume on the same day leaves banked progress alone',
      (tester) async {
    final now = DateTime.now();
    final todaysKind = dailyChallengeKindFor(_formatLocalDate(now));
    final todaysTarget = targetFor(todaysKind);

    // Today's challenge, already part-way done.
    final banked = DailyChallenge(
      date: _formatLocalDate(now),
      kind: todaysKind,
      target: todaysTarget,
      progress: 1,
      completed: false,
    );
    SharedPreferences.setMockInitialValues(<String, Object>{
      _v2Key: json.encode(banked.toJson()),
    });

    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('1/$todaysTarget'), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    // Resume is idempotent — progress survives.
    expect(find.text('1/$todaysTarget'), findsOneWidget);
    expect(find.text('0/$todaysTarget'), findsNothing);
  });
}
