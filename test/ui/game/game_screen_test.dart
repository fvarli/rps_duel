import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/ui/game/game_screen.dart';

void main() {
  testWidgets('Rock walks idle → cpuThinking → reveal', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GameScreen(cpuThinkingDelay: Duration(milliseconds: 200)),
      ),
    );

    expect(find.text('Choose your move'), findsOneWidget);
    expect(find.text('Next Round'), findsNothing);

    await tester.tap(find.text('Rock'));
    await tester.pump();

    expect(find.text('Choose your move'), findsNothing);
    expect(find.text('CPU is choosing…'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('CPU is choosing…'), findsNothing);
    expect(find.text('Next Round'), findsOneWidget);
    expect(find.text('Round 1 · History: 1 round'), findsOneWidget);
    expect(find.text('Rock'), findsAtLeastNWidgets(1));
  });

  testWidgets('Reset Cancel keeps the played round', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GameScreen(cpuThinkingDelay: Duration.zero),
      ),
    );
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
    await tester.pumpWidget(
      const MaterialApp(
        home: GameScreen(cpuThinkingDelay: Duration.zero),
      ),
    );
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
    await tester.pumpWidget(
      const MaterialApp(
        home: GameScreen(cpuThinkingDelay: Duration.zero),
      ),
    );
    expect(find.text('No rounds yet.'), findsOneWidget);

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();

    expect(find.text('No rounds yet.'), findsNothing);
    expect(find.text('Recent rounds'), findsOneWidget);
    expect(find.textContaining('1 · 🪨 Rock'), findsOneWidget);
  });
}
