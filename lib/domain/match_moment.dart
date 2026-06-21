import 'package:rps_duel/domain/duel_state.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';

/// Narrative moments that the player can discover by playing.
///
/// Each moment is a permanent souvenir of a single specific situation —
/// never a length, a volume, or a cumulative threshold. Detection is
/// trailing-window only: we look at the most-recent N entries in
/// [DuelState.history] (plus the post-resolve scores) and ask whether
/// that situation just occurred.
///
/// Order matters: when multiple moments unlock in the same round, they
/// fire in enum-index order via the existing unlock-toast queue.
enum MatchMomentId {
  firstWin,
  firstComeback,
  rivalBreaker,
  unstoppableRound,
  triplePrediction,
  counterMaster,
  turnaround,
}

/// A single recorded moment. We persist only the calendar date so the
/// Records screen can group moments without exposing exact timestamps.
class MatchMomentRecord {
  const MatchMomentRecord({required this.date});

  /// Local-calendar date string (`YYYY-MM-DD`) — same format used by
  /// [_formatLocalDate] in this file and [DailyChallenge].
  final String date;

  Map<String, Object?> toJson() => <String, Object?>{'date': date};

  static MatchMomentRecord fromJson(Map<String, dynamic> map) =>
      MatchMomentRecord(date: map['date'] as String);
}

/// Detect which (if any) new moments occurred on the round that just
/// resolved. Pure function — does no I/O.
///
/// [state] is the post-resolve [DuelState] (scores and history both
/// include the latest round).
/// [now] is supplied so callers can stamp the date deterministically in
/// tests.
/// [already] is the set of moments the player has already unlocked.
///
/// Returns only the newly-unlocked moments (never the existing ones).
Map<MatchMomentId, MatchMomentRecord> detectMoments({
  required DuelState state,
  required Set<MatchMomentId> already,
  required DateTime now,
}) {
  final out = <MatchMomentId, MatchMomentRecord>{};
  final history = state.history;
  final date = _formatLocalDate(now);

  void add(MatchMomentId id) {
    if (already.contains(id)) return;
    out[id] = MatchMomentRecord(date: date);
  }

  if (state.playerScore >= 1) add(MatchMomentId.firstWin);

  if (_matchesRivalBreaker(history)) add(MatchMomentId.rivalBreaker);
  if (_matchesFirstComeback(history)) add(MatchMomentId.firstComeback);
  if (_matchesUnstoppableRound(history)) add(MatchMomentId.unstoppableRound);
  if (_matchesTriplePrediction(history)) add(MatchMomentId.triplePrediction);
  if (_matchesCounterMaster(history)) add(MatchMomentId.counterMaster);
  if (_matchesTurnaround(history, state)) add(MatchMomentId.turnaround);

  return out;
}

/// Trailing 4 rounds end with [L, L, L, W].
bool _matchesRivalBreaker(List<RoundRecord> history) {
  if (history.length < 4) return false;
  final tail = history.sublist(history.length - 4);
  return tail[0].outcome == RoundOutcome.cpuWin &&
      tail[1].outcome == RoundOutcome.cpuWin &&
      tail[2].outcome == RoundOutcome.cpuWin &&
      tail[3].outcome == RoundOutcome.playerWin;
}

/// Trailing N rounds end with [L, L, …, W, W, W] where the loss run is
/// at least 2 and the win run is exactly 3. The round immediately before
/// the win run must be a loss, and there must be at least one more loss
/// before that.
bool _matchesFirstComeback(List<RoundRecord> history) {
  if (history.length < 5) return false;
  final n = history.length;
  // Last three must be wins; the one before them must be NOT a win — to
  // ensure the win run is exactly three at this point.
  if (history[n - 1].outcome != RoundOutcome.playerWin) return false;
  if (history[n - 2].outcome != RoundOutcome.playerWin) return false;
  if (history[n - 3].outcome != RoundOutcome.playerWin) return false;
  if (n >= 4 && history[n - 4].outcome == RoundOutcome.playerWin) return false;
  // The two rounds preceding the win run must both be CPU wins.
  if (history[n - 4].outcome != RoundOutcome.cpuWin) return false;
  if (history[n - 5].outcome != RoundOutcome.cpuWin) return false;
  return true;
}

/// Trailing N rounds end with [L, L, L, …, W, W, W, W, W] where the loss
/// run is at least 3 and the win run is exactly 5.
bool _matchesUnstoppableRound(List<RoundRecord> history) {
  if (history.length < 8) return false;
  final n = history.length;
  // Last five must be wins.
  for (var i = 0; i < 5; i++) {
    if (history[n - 1 - i].outcome != RoundOutcome.playerWin) return false;
  }
  // The round before the win run must NOT be a win, so the run is exactly 5.
  if (n >= 6 && history[n - 6].outcome == RoundOutcome.playerWin) return false;
  // The three rounds preceding the win run must all be CPU wins.
  for (var i = 0; i < 3; i++) {
    if (history[n - 6 - i].outcome != RoundOutcome.cpuWin) return false;
  }
  return true;
}

/// Trailing 3 rounds: same CPU move three times in a row, player played
/// the counter each round, all three are player wins.
bool _matchesTriplePrediction(List<RoundRecord> history) {
  if (history.length < 3) return false;
  final n = history.length;
  final a = history[n - 3];
  final b = history[n - 2];
  final c = history[n - 1];
  if (a.outcome != RoundOutcome.playerWin) return false;
  if (b.outcome != RoundOutcome.playerWin) return false;
  if (c.outcome != RoundOutcome.playerWin) return false;
  if (a.cpuMove != b.cpuMove || b.cpuMove != c.cpuMove) return false;
  // Guaranteed by player-win on each round, but assert for clarity.
  if (a.playerMove != _counter(a.cpuMove)) return false;
  if (b.playerMove != _counter(b.cpuMove)) return false;
  if (c.playerMove != _counter(c.cpuMove)) return false;
  return true;
}

/// Trailing 3 rounds: three different CPU moves, player played the
/// counter for each, all three are player wins.
bool _matchesCounterMaster(List<RoundRecord> history) {
  if (history.length < 3) return false;
  final n = history.length;
  final a = history[n - 3];
  final b = history[n - 2];
  final c = history[n - 1];
  if (a.outcome != RoundOutcome.playerWin) return false;
  if (b.outcome != RoundOutcome.playerWin) return false;
  if (c.outcome != RoundOutcome.playerWin) return false;
  final cpuMoves = <MoveChoice>{a.cpuMove, b.cpuMove, c.cpuMove};
  if (cpuMoves.length != 3) return false;
  return true;
}

/// Latest round is a player win AND the CPU still has at least a 2-point
/// lead post-resolve, meaning pre-resolve the gap was 3 or more.
bool _matchesTurnaround(List<RoundRecord> history, DuelState state) {
  if (history.isEmpty) return false;
  if (history.last.outcome != RoundOutcome.playerWin) return false;
  return state.cpuScore - state.playerScore >= 2;
}

MoveChoice _counter(MoveChoice cpu) {
  return switch (cpu) {
    MoveChoice.rock => MoveChoice.paper,
    MoveChoice.paper => MoveChoice.scissors,
    MoveChoice.scissors => MoveChoice.rock,
  };
}

String _formatLocalDate(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}
