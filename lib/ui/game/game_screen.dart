import 'package:flutter/material.dart';

import 'package:rps_duel/domain/duel_controller.dart';
import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/ui/game/move_button.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final DuelController _controller = DuelController();

  void _select(MoveChoice move) {
    _controller.selectMove(move);
    setState(() {});
  }

  void _next() {
    _controller.nextRound();
    setState(() {});
  }

  void _reset() {
    _controller.reset();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    final isReveal = state.phase == DuelPhase.reveal;
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
                          isReveal ? null : () => _select(MoveChoice.rock),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MoveButton(
                      emoji: '📄',
                      label: 'Paper',
                      onPressed:
                          isReveal ? null : () => _select(MoveChoice.paper),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MoveButton(
                      emoji: '✂️',
                      label: 'Scissors',
                      onPressed:
                          isReveal ? null : () => _select(MoveChoice.scissors),
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
                  onPressed: _reset,
                  child: const Text('Reset Game'),
                ),
              ),
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
