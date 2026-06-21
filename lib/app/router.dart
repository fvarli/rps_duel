import 'package:go_router/go_router.dart';

import 'package:rps_duel/domain/achievement.dart';
import 'package:rps_duel/domain/match_moment.dart';
import 'package:rps_duel/domain/round_record.dart';
import 'package:rps_duel/ui/game/achievements_screen.dart';
import 'package:rps_duel/ui/game/game_screen.dart';
import 'package:rps_duel/ui/game/records_screen.dart';

class RecordsExtra {
  const RecordsExtra({required this.history, required this.moments});

  final List<RoundRecord> history;
  final Map<MatchMomentId, MatchMomentRecord> moments;
}

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
        GoRoute(
          path: 'records',
          name: 'records',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is RecordsExtra) {
              return RecordsScreen(
                history: extra.history,
                moments: extra.moments,
              );
            }
            return const RecordsScreen(
              history: <RoundRecord>[],
              moments: <MatchMomentId, MatchMomentRecord>{},
            );
          },
        ),
      ],
    ),
  ],
);
