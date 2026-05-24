import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_duel/app/locale_scope.dart';
import 'package:rps_duel/data/local_difficulty_storage.dart';
import 'package:rps_duel/domain/cpu_difficulty.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/rps_engine.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
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
  });

  testWidgets('Rock walks idle → cpuThinking → reveal', (tester) async {
    await tester.pumpWidget(_buildApp(delay: const Duration(milliseconds: 500)));
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

  testWidgets('Settings → Reset data clears the played round',
      (tester) async {
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

  testWidgets(
      'Settings → Difficulty → Easy persists and surfaces in settings',
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
    expect(find.text('Win 3 rounds with Scissors'), findsOneWidget);
    expect(find.text('0/3'), findsOneWidget);
  });

  testWidgets(
      'winning a round with Scissors advances the daily challenge to 1/3',
      (tester) async {
    // CPU plays paper → scissors wins.
    await tester.pumpWidget(
      _buildApp(engine: _FixedCpuEngine(MoveChoice.paper)),
    );
    await tester.pumpAndSettle();

    expect(find.text('0/3'), findsOneWidget);

    await tester.tap(find.text('Scissors'));
    await tester.pumpAndSettle();

    expect(find.text('1/3'), findsOneWidget);
  });
}
