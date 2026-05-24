import 'dart:async';

import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = DuelController(cpuThinkingDelay: widget.cpuThinkingDelay);
    _controller.onStateChanged = _handleStateChanged;
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

  void _select(MoveChoice move) {
    unawaited(_controller.selectMoveWithDelay(move));
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _ScoreCard(label: 'Player', value: state.playerScore),
                  _ScoreCard(label: 'CPU', value: state.cpuScore),
                  _ScoreCard(label: 'Ties', value: state.ties),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Round ${state.roundCount} · History: $historyCount $historyWord',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 32),
              if (isReveal)
                _RevealArea(
                  playerMove: state.playerMove!,
                  cpuMove: state.cpuMove!,
                  outcome: state.outcome!,
                )
              else if (isThinking)
                Center(
                  child: Text(
                    'CPU is choosing…',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              else
                Center(
                  child: Text(
                    'Choose your move',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              const SizedBox(height: 40),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MoveButton(
                      emoji: '🪨',
                      label: 'Rock',
                      onPressed:
                          isIdle ? () => _select(MoveChoice.rock) : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MoveButton(
                      emoji: '📄',
                      label: 'Paper',
                      onPressed:
                          isIdle ? () => _select(MoveChoice.paper) : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MoveButton(
                      emoji: '✂️',
                      label: 'Scissors',
                      onPressed:
                          isIdle ? () => _select(MoveChoice.scissors) : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
              _HistorySection(history: state.history),
            ],
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
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(label, style: theme.textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(
              '$value',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
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
        const SizedBox(height: 20),
        Text(
          _outcomeText(outcome),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
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
          for (var i = 0; i < visible.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${total - i} · '
                '${_emojiFor(visible[i].playerMove)} ${_labelFor(visible[i].playerMove)}'
                '  vs  '
                '${_emojiFor(visible[i].cpuMove)} ${_labelFor(visible[i].cpuMove)}'
                '  ·  ${_outcomeText(visible[i].outcome)}',
                style: theme.textTheme.bodySmall,
              ),
            ),
      ],
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
