import 'package:go_router/go_router.dart';

import 'package:rps_duel/app/home_placeholder.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePlaceholderScreen(),
    ),
  ],
);
