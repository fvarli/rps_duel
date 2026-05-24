import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/ui/game/game_screen.dart';

void main() {
  testWidgets('tapping Rock triggers reveal state', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: GameScreen()));

    expect(find.text('Choose your move'), findsOneWidget);
    expect(find.text('Next Round'), findsNothing);
    expect(find.text('Round 0 · History: 0 rounds'), findsOneWidget);

    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();

    expect(find.text('Choose your move'), findsNothing);
    expect(find.text('Next Round'), findsOneWidget);
    expect(find.text('Round 1 · History: 1 round'), findsOneWidget);
    // "Rock" now appears in two places — the disabled MoveButton AND
    // the _MoveDisplay under "You" — so we assert ≥1.
    expect(find.text('Rock'), findsAtLeastNWidgets(1));
  });
}
