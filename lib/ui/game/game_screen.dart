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

    return Scaffold(
      appBar: AppBar(title: const Text('RPS Duel')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _ScoresRow(
                playerScore: state.playerScore,
                cpuScore: state.cpuScore,
                ties: state.ties,
              ),
              Text(
                'Round ${state.roundCount}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (isReveal)
                _RevealPanel(
                  playerMove: state.playerMove!,
                  cpuMove: state.cpuMove!,
                  outcome: state.outcome!,
                )
              else
                Text(
                  'Choose your move',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MoveButton(
                      label: 'Rock',
                      onPressed: isReveal ? null : () => _select(MoveChoice.rock),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MoveButton(
                      label: 'Paper',
                      onPressed: isReveal ? null : () => _select(MoveChoice.paper),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MoveButton(
                      label: 'Scissors',
                      onPressed:
                          isReveal ? null : () => _select(MoveChoice.scissors),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  if (isReveal)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.tonal(
                        onPressed: _next,
                        child: const Text('Next Round'),
                      ),
                    ),
                  if (isReveal) const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _reset,
                      child: const Text('Reset Game'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoresRow extends StatelessWidget {
  const _ScoresRow({
    required this.playerScore,
    required this.cpuScore,
    required this.ties,
  });

  final int playerScore;
  final int cpuScore;
  final int ties;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _ScoreCell(label: 'Player', value: playerScore),
        _ScoreCell(label: 'CPU', value: cpuScore),
        _ScoreCell(label: 'Ties', value: ties),
      ],
    );
  }
}

class _ScoreCell extends StatelessWidget {
  const _ScoreCell({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 4),
        Text('$value', style: theme.textTheme.headlineMedium),
      ],
    );
  }
}

class _RevealPanel extends StatelessWidget {
  const _RevealPanel({
    required this.playerMove,
    required this.cpuMove,
    required this.outcome,
  });

  final MoveChoice playerMove;
  final MoveChoice cpuMove;
  final RoundOutcome outcome;

  String _outcomeText() {
    return switch (outcome) {
      RoundOutcome.playerWin => 'You win!',
      RoundOutcome.cpuWin => 'CPU wins!',
      RoundOutcome.tie => 'Tie',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Text('You: ${playerMove.name}', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text('CPU: ${cpuMove.name}', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Text(
          _outcomeText(),
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }
}
