import 'package:go_router/go_router.dart';

import 'package:rps_duel/ui/game/game_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const GameScreen(),
    ),
  ],
);
