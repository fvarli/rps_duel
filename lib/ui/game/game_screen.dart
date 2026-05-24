import 'dart:async';

import 'package:flutter/material.dart';

import 'package:rps_duel/data/local_game_storage.dart';
import 'package:rps_duel/domain/duel_controller.dart';
import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';
import 'package:rps_duel/ui/game/move_button.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    this.cpuThinkingDelay = const Duration(milliseconds: 500),
  });

  final Duration cpuThinkingDelay;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final DuelController _controller;
  LocalGameStorage? _storage;

  @override
  void initState() {
    super.initState();
    _controller = DuelController(cpuThinkingDelay: widget.cpuThinkingDelay);
    _controller.onStateChanged = _handleStateChanged;
    unawaited(_loadAndApply());
  }

  @override
  void dispose() {
    _controller.onStateChanged = null;
    super.dispose();
  }

  void _handleStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadAndApply() async {
    final storage = await LocalGameStorage.open();
    if (!mounted) return;
    _storage = storage;
    final s = _controller.state;
    final pristine = s.playerScore == 0 &&
        s.cpuScore == 0 &&
        s.ties == 0 &&
        s.roundCount == 0 &&
        s.history.isEmpty &&
        s.phase == DuelPhase.idle;
    if (!pristine) return;
    final restored = storage.load();
    if (restored != null) {
      _controller.restoreFrom(restored);
    }
  }

  void _select(MoveChoice move) {
    unawaited(_runRound(move));
  }

  Future<void> _runRound(MoveChoice move) async {
    await _controller.selectMoveWithDelay(move);
    if (!mounted) return;
    await _storage?.save(_controller.state);
  }

  void _next() {
    _controller.nextRound();
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset game?'),
        content: const Text('Scores and round history will be cleared.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed ?? false) {
      _controller.reset();
      await _storage?.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    final phase = state.phase;
    final isIdle = phase == DuelPhase.idle;
    final isThinking =
        phase == DuelPhase.playerSelected || phase == DuelPhase.cpuThinking;
    final isReveal = phase == DuelPhase.reveal;
    final historyCount = state.history.length;
    final historyWord = historyCount == 1 ? 'round' : 'rounds';

    return Scaffold(
      appBar: AppBar(title: const Text('RPS Duel')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: _ScoreCard(
                          label: 'Player',
                          value: state.playerScore,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ScoreCard(
                          label: 'CPU',
                          value: state.cpuScore,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ScoreCard(
                          label: 'Ties',
                          value: state.ties,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Round ${state.roundCount} · History: $historyCount $historyWord',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DuelSurface(
                    child: isReveal
                        ? _RevealArea(
                            playerMove: state.playerMove!,
                            cpuMove: state.cpuMove!,
                            outcome: state.outcome!,
                          )
                        : isThinking
                            ? Text(
                                'CPU is choosing…',
                                style:
                                    Theme.of(context).textTheme.titleLarge,
                              )
                            : Text(
                                'Choose your move',
                                style:
                                    Theme.of(context).textTheme.titleLarge,
                              ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MoveButton(
                          emoji: '🪨',
                          label: 'Rock',
                          onPressed: isIdle
                              ? () => _select(MoveChoice.rock)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MoveButton(
                          emoji: '📄',
                          label: 'Paper',
                          onPressed: isIdle
                              ? () => _select(MoveChoice.paper)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MoveButton(
                          emoji: '✂️',
                          label: 'Scissors',
                          onPressed: isIdle
                              ? () => _select(MoveChoice.scissors)
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (isReveal) ...<Widget>[
                    SizedBox(
                      height: 48,
                      child: FilledButton.tonal(
                        onPressed: _next,
                        child: const Text('Next Round'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        unawaited(_confirmReset());
                      },
                      child: const Text('Reset Game'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _HistorySection(history: state.history),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label, style: theme.textTheme.labelMedium),
            ),
            const SizedBox(height: 2),
            Text(
              '$value',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DuelSurface extends StatelessWidget {
  const _DuelSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: child,
    );
  }
}

class _RevealArea extends StatelessWidget {
  const _RevealArea({
    required this.playerMove,
    required this.cpuMove,
    required this.outcome,
  });

  final MoveChoice playerMove;
  final MoveChoice cpuMove;
  final RoundOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _MoveDisplay(sideLabel: 'You', move: playerMove),
            Text(
              'VS',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            _MoveDisplay(sideLabel: 'CPU', move: cpuMove),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _outcomeText(outcome),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: _outcomeColor(theme, outcome),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _MoveDisplay extends StatelessWidget {
  const _MoveDisplay({required this.sideLabel, required this.move});

  final String sideLabel;
  final MoveChoice move;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(sideLabel, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(_emojiFor(move), style: const TextStyle(fontSize: 56)),
        const SizedBox(height: 4),
        Text(_labelFor(move), style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.history});

  final List<RoundRecord> history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = history.length;
    final visible = history.reversed.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Divider(height: 32),
        Text('Recent rounds', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No rounds yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          for (var i = 0; i < visible.length; i++) ...<Widget>[
            _HistoryRow(roundNumber: total - i, record: visible[i]),
            if (i < visible.length - 1)
              Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant,
              ),
          ],
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.roundNumber, required this.record});

  final int roundNumber;
  final RoundRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text('$roundNumber', style: theme.textTheme.labelSmall),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${_emojiFor(record.playerMove)} ${_labelFor(record.playerMove)}'
              '  vs  '
              '${_emojiFor(record.cpuMove)} ${_labelFor(record.cpuMove)}',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _outcomeText(record.outcome),
            style: theme.textTheme.bodySmall?.copyWith(
              color: _outcomeColor(theme, record.outcome),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String _emojiFor(MoveChoice move) {
  return switch (move) {
    MoveChoice.rock => '🪨',
    MoveChoice.paper => '📄',
    MoveChoice.scissors => '✂️',
  };
}

String _labelFor(MoveChoice move) {
  return switch (move) {
    MoveChoice.rock => 'Rock',
    MoveChoice.paper => 'Paper',
    MoveChoice.scissors => 'Scissors',
  };
}

String _outcomeText(RoundOutcome outcome) {
  return switch (outcome) {
    RoundOutcome.playerWin => 'You win!',
    RoundOutcome.cpuWin => 'CPU wins!',
    RoundOutcome.tie => "It's a tie!",
  };
}

Color _outcomeColor(ThemeData theme, RoundOutcome outcome) {
  return switch (outcome) {
    RoundOutcome.playerWin => theme.colorScheme.primary,
    RoundOutcome.cpuWin => theme.colorScheme.error,
    RoundOutcome.tie => theme.colorScheme.onSurfaceVariant,
  };
}
