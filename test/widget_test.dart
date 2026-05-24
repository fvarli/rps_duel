import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rps_duel/main.dart';

void main() {
  testWidgets('Phase 0 bootstrap shell renders home placeholder', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: RpsDuelApp()));
    await tester.pumpAndSettle();

    expect(find.text('RPS Duel'), findsOneWidget);
    expect(find.text('com.lunexa.games.rpsduel'), findsOneWidget);
    expect(find.text('Phase 0 bootstrap'), findsOneWidget);
  });
}
