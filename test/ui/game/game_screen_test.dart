import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/app/locale_scope.dart';
import 'package:rps_duel/data/local_difficulty_storage.dart';
import 'package:rps_duel/domain/cpu_difficulty.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/rps_engine.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/achievement_unlock_overlay.dart';
import 'package:rps_duel/ui/game/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FixedCpuEngine extends RpsEngine {
  _FixedCpuEngine(this._cpu);

  final MoveChoice _cpu;

  @override
  MoveChoice cpuMove() => _cpu;

  @override
  MoveChoice cpuMoveFor({
    required MoveChoice playerMove,
    required CpuDifficulty difficulty,
  }) =>
      _cpu;
}

Widget _buildApp({
  Locale? locale,
  Duration delay = Duration.zero,
  RpsEngine? engine,
}) {
  final controller = ValueNotifier<Locale?>(locale);
  return LocaleScope(
    controller: controller,
    child: ValueListenableBuilder<Locale?>(
      valueListenable: controller,
      builder: (ctx, current, _) => MaterialApp(
        locale: current,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: GameScreen(cpuThinkingDelay: delay, engine: engine),
      ),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    AchievementUnlockOverlay.debugReset();
  });

  testWidgets('Rock walks idle → cpuThinking → reveal', (tester) async {
    await tester
        .pumpWidget(_buildApp(delay: const Duration(milliseconds: 500)));
    await tester.pumpAndSettle();

    expect(find.text('Choose your move'), findsOneWidget);
    expect(find.text('Next Round'), findsNothing);

    await tester.tap(find.text('Rock'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Choose your move'), findsNothing);
    expect(find.text('CPU is choosing…'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('CPU is choosing…'), findsNothing);
    expect(find.text('Next Round'), findsOneWidget);
    expect(find.text('Round 1 · History: 1 round'), findsOneWidget);
    expect(find.text('Rock'), findsAtLeastNWidgets(1));
  });

  testWidgets('Reset Cancel keeps the played round', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();

    expect(find.text('Round 1 · History: 1 round'), findsOneWidget);
    expect(find.text('Next Round'), findsOneWidget);

    await tester.ensureVisible(find.text('Reset Game'));
    await tester.tap(find.text('Reset Game'));
    await tester.pumpAndSettle();
    expect(find.text('Reset game?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Reset game?'), findsNothing);
    expect(find.text('Round 1 · History: 1 round'), findsOneWidget);
    expect(find.text('Next Round'), findsOneWidget);
    expect(find.text('No rounds yet.'), findsNothing);
  });

  testWidgets('Reset confirms and clears scores/history', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Reset Game'));
    await tester.tap(find.text('Reset Game'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(find.text('Reset game?'), findsNothing);
    expect(find.text('Round 0 · History: 0 rounds'), findsOneWidget);
    expect(find.text('Choose your move'), findsOneWidget);
    expect(find.text('No rounds yet.'), findsOneWidget);
    expect(find.text('Next Round'), findsNothing);
  });

  testWidgets('history shows latest played round after reveal', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('No rounds yet.'), findsOneWidget);

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();

    expect(find.text('No rounds yet.'), findsNothing);
    expect(find.text('Recent rounds'), findsOneWidget);
    expect(find.textContaining('🪨 Rock  vs'), findsOneWidget);
    expect(find.text('1'), findsAtLeastNWidgets(1));
  });

  testWidgets('renders on a 360x640 viewport without overflow', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders Turkish locale strings', (tester) async {
    await tester.pumpWidget(_buildApp(locale: const Locale('tr')));
    await tester.pumpAndSettle();

    expect(find.text('Hamleni seç'), findsOneWidget);
    expect(find.text('Taş'), findsAtLeastNWidgets(1));
    expect(find.text('Oyunu Sıfırla'), findsOneWidget);
  });

  testWidgets('settings button opens the settings sheet', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Reset data'), findsOneWidget);
    expect(find.text('About RPS Duel'), findsOneWidget);
  });

  testWidgets('Settings → Language → Türkçe switches UI to Turkish',
      (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Türkçe'));
    await tester.pumpAndSettle();

    expect(find.text('Hamleni seç'), findsOneWidget);
    expect(find.text('Taş'), findsAtLeastNWidgets(1));
  });

  testWidgets('Settings → Language → Español switches UI to Spanish',
      (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();

    expect(find.text('Elige tu jugada'), findsOneWidget);
    expect(find.text('Piedra'), findsAtLeastNWidgets(1));
  });

  testWidgets('Settings → Reset data clears the played round', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();
    expect(find.text('Round 1 · History: 1 round'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset data'));
    await tester.pumpAndSettle();

    expect(find.text('Reset game?'), findsOneWidget);
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(find.text('Round 0 · History: 0 rounds'), findsOneWidget);
    expect(find.text('No rounds yet.'), findsOneWidget);
  });

  testWidgets('Settings → About shows brand + store title + tagline',
      (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About RPS Duel'));
    await tester.pumpAndSettle();

    expect(find.text('RPS Duel'), findsAtLeastNWidgets(1));
    expect(find.text('RPS Duel: Rock Paper Scissors'), findsOneWidget);
    expect(
      find.text('A pocketable 30-second rock-paper-scissors duel.'),
      findsOneWidget,
    );
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('stats line is visible on initial render', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(
      find.text('Streak: 0 · Best: 0 · Win rate: 0%'),
      findsOneWidget,
    );
  });

  testWidgets('Settings → Difficulty opens the difficulty picker',
      (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Difficulty'), findsOneWidget);
    // Difficulty tile subtitle shows the default (Normal).
    expect(find.text('Normal'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('Difficulty'));
    await tester.pumpAndSettle();

    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
  });

  testWidgets('Settings → Difficulty → Easy persists and surfaces in settings',
      (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Difficulty'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Easy'));
    await tester.pumpAndSettle();

    // Reopen settings — Difficulty tile subtitle should now read "Easy".
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Easy'), findsAtLeastNWidgets(1));

    // Verify persistence via the storage abstraction (avoids
    // mock-vs-runtime key-prefix ambiguity).
    final storage = await DifficultyStorage.open();
    expect(storage.load(), CpuDifficulty.easy);
  });

  testWidgets(
      'Daily Challenge card visible with 0/3 progress on initial render',
      (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Daily Challenge'), findsOneWidget);
    // The exact description + target depend on today's deterministic
    // rotation (see DailyChallengeKind); we only assert the card renders
    // at a zero-progress fraction. Per-kind copy is covered in
    // daily_challenge_card_test.dart.
    expect(find.textContaining(RegExp(r'^0/\d+$')), findsOneWidget);
  });

  testWidgets(
      'winning a round advances the daily challenge by at most one step',
      (tester) async {
    // CPU plays scissors → rock wins. Picks Rock so the test stays valid
    // across rotation days that key off a specific move (winWithPaper,
    // winWithScissors, etc.). The challenge either advances by 1 (kinds
    // that bump on any win, or that match Rock specifically) or stays at
    // 0 (kinds that bump on tie / on a non-Rock move). Either way it
    // exercises the integration path through _updateChallenge.
    await tester.pumpWidget(
      _buildApp(engine: _FixedCpuEngine(MoveChoice.scissors)),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining(RegExp(r'^0/\d+$')), findsOneWidget);

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();

    // After one win, progress is either 0/N (kind ignored this round) or
    // 1/N (kind matched). Both are valid outcomes for the integration.
    final stillZero =
        find.textContaining(RegExp(r'^0/\d+$')).evaluate().isNotEmpty;
    final advancedOne =
        find.textContaining(RegExp(r'^1/\d+$')).evaluate().isNotEmpty;
    expect(stillZero || advancedOne, isTrue);
  });

  testWidgets('achievements card shows 0/4 and empty state on initial render',
      (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('0/4 unlocked'), findsOneWidget);
    expect(find.text('No achievements yet.'), findsOneWidget);
  });

  testWidgets('winning a round unlocks First Win and surfaces a chip',
      (tester) async {
    // CPU plays scissors → rock wins.
    await tester.pumpWidget(
      _buildApp(engine: _FixedCpuEngine(MoveChoice.scissors)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();

    expect(find.text('1/4 unlocked'), findsOneWidget);
    // 'First Win' appears in the achievement chip; the unlock toast also
    // shows it transiently for ~3s after the round resolves.
    expect(find.text('First Win'), findsAtLeastNWidgets(1));
    expect(find.text('No achievements yet.'), findsNothing);
  });

  testWidgets('Settings → Reset data preserves unlocked achievements',
      (tester) async {
    await tester.pumpWidget(
      _buildApp(engine: _FixedCpuEngine(MoveChoice.scissors)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();
    expect(find.text('1/4 unlocked'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(find.text('Round 0 · History: 0 rounds'), findsOneWidget);
    // Chip survives reset; toast may still be holding (~3s lifetime).
    expect(find.text('First Win'), findsAtLeastNWidgets(1));
    expect(find.text('1/4 unlocked'), findsOneWidget);
  });

  testWidgets('winning the first round surfaces the achievement unlock toast',
      (tester) async {
    await tester.pumpWidget(
      _buildApp(engine: _FixedCpuEngine(MoveChoice.scissors)),
    );
    await tester.pumpAndSettle();

    expect(find.text('ACHIEVEMENT UNLOCKED'), findsNothing);

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();

    // Toast inserted and enter animation completed.
    expect(find.text('ACHIEVEMENT UNLOCKED'), findsOneWidget);
    // 'First Win' appears in both the chip and the toast title.
    expect(find.text('First Win'), findsAtLeastNWidgets(1));

    // Advance past the hold + exit; the toast removes itself.
    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pumpAndSettle();

    expect(find.text('ACHIEVEMENT UNLOCKED'), findsNothing);
    // The chip is still on screen after the achievement toast dismisses.
    // 'First Win' is also the moment title — the moment toast is now in
    // the queue and may be on screen or about to be, so allow either.
    expect(find.text('First Win'), findsAtLeastNWidgets(1));
  });

  testWidgets('losing a round does not surface a toast', (tester) async {
    // CPU plays Paper → Rock loses.
    await tester.pumpWidget(
      _buildApp(engine: _FixedCpuEngine(MoveChoice.paper)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();

    expect(find.text('ACHIEVEMENT UNLOCKED'), findsNothing);
    expect(find.text('MEMORABLE MOMENT'), findsNothing);
    expect(find.text('0/4 unlocked'), findsOneWidget);
  });

  testWidgets(
    'winning the first round queues both the achievement toast and the moment toast',
    (tester) async {
      // CPU plays scissors → rock wins. Triggers both:
      //  - achievement firstWin (existing)
      //  - moment firstWin (new)
      await tester.pumpWidget(
        _buildApp(engine: _FixedCpuEngine(MoveChoice.scissors)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Rock'));
      await tester.pumpAndSettle();

      // Achievements enqueue first (sorted ahead in the call site), so
      // the first toast on screen is the achievement.
      expect(find.text('ACHIEVEMENT UNLOCKED'), findsOneWidget);
      // 'First Win' appears in the achievement chip AND in the active toast.
      expect(find.text('First Win'), findsAtLeastNWidgets(1));

      // Drain the achievement toast; the moment toast should follow.
      await tester.pump(const Duration(milliseconds: 2400));
      await tester.pumpAndSettle();

      expect(find.text('ACHIEVEMENT UNLOCKED'), findsNothing);
      expect(find.text('MEMORABLE MOMENT'), findsOneWidget);
      // 'First Win' is still on screen because the moment shares the title.
      expect(find.text('First Win'), findsAtLeastNWidgets(1));

      // Drain the moment toast.
      await tester.pump(const Duration(milliseconds: 2400));
      await tester.pumpAndSettle();
      expect(find.text('MEMORABLE MOMENT'), findsNothing);
    },
  );
}
