import 'package:go_router/go_router.dart';

import 'package:rps_duel/domain/achievement.dart';
import 'package:rps_duel/ui/game/achievements_screen.dart';
import 'package:rps_duel/ui/game/game_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const GameScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'achievements',
          name: 'achievements',
          builder: (context, state) {
            final extra = state.extra;
            final unlocked = extra is Map<AchievementId, DateTime?>
                ? extra
                : const <AchievementId, DateTime?>{};
            return AchievementsScreen(unlocked: unlocked);
          },
        ),
      ],
    ),
  ],
);
