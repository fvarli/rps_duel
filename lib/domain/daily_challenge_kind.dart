/// The set of hand-authored daily-challenge archetypes that rotate by
/// local calendar day. Library size is small and stable on purpose —
/// the daily rhythm should feel curated, not random.
///
/// Order in [DailyChallengeKind.values] is part of the rotation contract:
/// reordering or removing values changes which kind a given date maps to
/// and therefore must be considered a breaking change for v2 storage.
enum DailyChallengeKind {
  /// Win [target] rounds today regardless of move chosen.
  winRounds,

  /// Win [target] rounds today specifically by playing Rock.
  winWithRock,

  /// Win [target] rounds today specifically by playing Paper.
  winWithPaper,

  /// Win [target] rounds today specifically by playing Scissors.
  /// Pre-rotation behavior; preserved exactly for v1-migrated entries.
  winWithScissors,

  /// Tie [target] rounds today.
  getTies,

  /// Reach a single in-session winning streak of [target] rounds. Reads
  /// from the existing [DuelState.currentStreak] — no new state required.
  winStreak,

  /// Play [target] rounds today regardless of outcome. The calm day.
  playRounds,
}

/// Per-kind target tuning. Hand-picked so each archetype takes roughly
/// the same time-on-screen for a competent player; the streak day is
/// slightly tighter (intense), the play-rounds day is slightly looser
/// (gentle).
const Map<DailyChallengeKind, int> dailyChallengeKindTarget =
    <DailyChallengeKind, int>{
  DailyChallengeKind.winRounds: 3,
  DailyChallengeKind.winWithRock: 2,
  DailyChallengeKind.winWithPaper: 2,
  DailyChallengeKind.winWithScissors: 3,
  DailyChallengeKind.getTies: 2,
  DailyChallengeKind.winStreak: 3,
  DailyChallengeKind.playRounds: 5,
};

int targetFor(DailyChallengeKind kind) => dailyChallengeKindTarget[kind]!;

/// Deterministic rotation: given a local-date string (`YYYY-MM-DD`),
/// returns today's archetype. Same player + same date → same kind,
/// regardless of cold-start vs after-foreground, regardless of timezone
/// offset within the day.
///
/// The hash is a byte-sum mod library length — not cryptographically
/// meaningful, but trivially auditable and pulls no extra packages.
DailyChallengeKind dailyChallengeKindFor(String localDate) {
  var sum = 0;
  for (final byte in localDate.codeUnits) {
    sum = (sum + byte) & 0x7fffffff;
  }
  return DailyChallengeKind.values[sum % DailyChallengeKind.values.length];
}
