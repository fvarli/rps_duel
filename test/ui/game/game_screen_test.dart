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
}
