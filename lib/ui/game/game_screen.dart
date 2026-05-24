import 'dart:async';

import 'package:flutter/material.dart';

import 'package:rps_duel/app/locale_scope.dart';
import 'package:rps_duel/data/local_achievement_storage.dart';
import 'package:rps_duel/data/local_daily_challenge_storage.dart';
import 'package:rps_duel/data/local_difficulty_storage.dart';
import 'package:rps_duel/data/local_game_storage.dart';
import 'package:rps_duel/domain/achievement.dart';
import 'package:rps_duel/domain/cpu_difficulty.dart';
import 'package:rps_duel/domain/daily_challenge.dart';
import 'package:rps_duel/domain/duel_controller.dart';
import 'package:rps_duel/domain/duel_phase.dart';
import 'package:rps_duel/domain/duel_state.dart';
import 'package:rps_duel/domain/move_choice.dart';
import 'package:rps_duel/domain/round_outcome.dart';
import 'package:rps_duel/domain/round_record.dart';
import 'package:rps_duel/domain/rps_engine.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/achievements_card.dart';
import 'package:rps_duel/ui/game/daily_challenge_card.dart';
import 'package:rps_duel/ui/game/difficulty_picker_sheet.dart';
import 'package:rps_duel/ui/game/language_picker_sheet.dart';
import 'package:rps_duel/ui/game/move_button.dart';
import 'package:rps_duel/ui/game/settings_sheet.dart';
import 'package:rps_duel/ui/theme/tactile_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    this.cpuThinkingDelay = const Duration(milliseconds: 500),
    this.engine,
  });

  final Duration cpuThinkingDelay;
  final RpsEngine? engine;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final DuelController _controller;
  LocalGameStorage? _storage;
  DifficultyStorage? _difficultyStorage;
  DailyChallengeStorage? _challengeStorage;
  DailyChallenge _challenge = DailyChallenge.initialFor(DateTime.now());
  AchievementStorage? _achievementStorage;
  Set<AchievementId> _achievements = <AchievementId>{};

  @override
  void initState() {
    super.initState();
    _controller = DuelController(
      cpuThinkingDelay: widget.cpuThinkingDelay,
      engine: widget.engine,
    );
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

  Widget _phaseChild(DuelState state, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return switch (state.phase) {
      DuelPhase.reveal => _RevealArea(
          key: const ValueKey<String>('reveal'),
          playerMove: state.playerMove!,
          cpuMove: state.cpuMove!,
          outcome: state.outcome!,
        ),
      DuelPhase.playerSelected || DuelPhase.cpuThinking => Text(
          l10n.phaseThinking,
          key: const ValueKey<String>('thinking'),
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      DuelPhase.idle => Text(
          l10n.phaseIdle,
          key: const ValueKey<String>('idle'),
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
    };
  }

  Future<void> _loadAndApply() async {
    final storage = await LocalGameStorage.open();
    final difficultyStorage = await DifficultyStorage.open();
    final challengeStorage = await DailyChallengeStorage.open();
    if (!mounted) return;
    _storage = storage;
    _difficultyStorage = difficultyStorage;
    _challengeStorage = challengeStorage;
    _controller.setDifficulty(difficultyStorage.load());

    final loadedChallenge = challengeStorage.load();
    final today = DateTime.now();
    if (loadedChallenge != null && loadedChallenge.isToday(today)) {
      setState(() => _challenge = loadedChallenge);
    } else {
      final fresh = DailyChallenge.initialFor(today);
      setState(() => _challenge = fresh);
      unawaited(challengeStorage.save(fresh));
    }

    final achievementStorage = await AchievementStorage.open();
    if (!mounted) return;
    _achievementStorage = achievementStorage;
    setState(() => _achievements = achievementStorage.load());

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

  Future<void> _setDifficulty(CpuDifficulty difficulty) async {
    _controller.setDifficulty(difficulty);
    await _difficultyStorage?.save(difficulty);
  }

  void _updateChallenge() {
    final history = _controller.state.history;
    if (history.isEmpty) return;
    final last = history.last;
    final next = _challenge.advanceFor(last.playerMove, last.outcome);
    if (next.progress != _challenge.progress) {
      setState(() => _challenge = next);
    }
  }

  void _updateAchievements() {
    final next = evaluateAchievements(
      state: _controller.state,
      dailyChallenge: _challenge,
      already: _achievements,
    );
    if (next.length != _achievements.length) {
      setState(() => _achievements = next);
    }
  }

  void _select(MoveChoice move) {
    unawaited(_runRound(move));
  }

  Future<void> _runRound(MoveChoice move) async {
    await _controller.selectMoveWithDelay(move);
    if (!mounted) return;
    _updateChallenge();
    _updateAchievements();
    await _storage?.save(_controller.state);
    await _challengeStorage?.save(_challenge);
    await _achievementStorage?.save(_achievements);
  }

  void _next() {
    _controller.nextRound();
  }

  Future<void> _showAboutDialog() async {
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.appName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'RPS Duel: Rock Paper Scissors',
              style: Theme.of(ctx).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Text(l10n.aboutDescription),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.aboutClose),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetDialogTitle),
        content: Text(l10n.resetDialogBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.resetConfirm),
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
    final l10n = AppLocalizations.of(context);
    final state = _controller.state;
    final phase = state.phase;
    final isIdle = phase == DuelPhase.idle;
    final isReveal = phase == DuelPhase.reveal;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settingsTitle,
            onPressed: () {
              unawaited(showSettingsSheet(
                context,
                currentDifficulty: _controller.difficulty,
                onDifficulty: () => unawaited(
                  showDifficultyPicker(
                    context,
                    _controller.difficulty,
                    (d) => unawaited(_setDifficulty(d)),
                  ),
                ),
                onLanguage: () => unawaited(
                  showLanguagePicker(context, LocaleScope.of(context)),
                ),
                onResetData: () => unawaited(_confirmReset()),
                onAbout: () => unawaited(_showAboutDialog()),
              ),);
            },
          ),
        ],
      ),
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
                      _ScoreCard(
                        label: l10n.scoreLabelPlayer,
                        value: state.playerScore,
                      ),
                      _ScoreCard(
                        label: l10n.scoreLabelCpu,
                        value: state.cpuScore,
                      ),
                      _ScoreCard(
                        label: l10n.scoreLabelTies,
                        value: state.ties,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      l10n.summaryLine(state.roundCount, state.history.length),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      l10n.statsLine(
                        state.currentStreak,
                        state.bestStreak,
                        state.winRatePercent,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DailyChallengeCard(challenge: _challenge),
                  const SizedBox(height: 16),
                  AchievementsCard(unlocked: _achievements),
                  const SizedBox(height: 16),
                  _DuelSurface(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 220),
                      alignment: Alignment.topCenter,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: _phaseChild(state, l10n),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MoveButton(
                          emoji: '🪨',
                          label: l10n.moveRock,
                          onPressed: isIdle
                              ? () => _select(MoveChoice.rock)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MoveButton(
                          emoji: '📄',
                          label: l10n.movePaper,
                          onPressed: isIdle
                              ? () => _select(MoveChoice.paper)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MoveButton(
                          emoji: '✂️',
                          label: l10n.moveScissors,
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
                        child: Text(l10n.nextRound),
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
                      child: Text(l10n.resetGame),
                    ),
                  ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: TactileColors.paperEdge,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              '$value',
              key: ValueKey<int>(value),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
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
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: TactileColors.shadowInk10,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: child,
    );
  }
}

class _RevealArea extends StatelessWidget {
  const _RevealArea({
    super.key,
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
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _MoveDisplay(sideLabel: l10n.sideYou, move: playerMove),
            Text(
              l10n.vsLabel,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            _MoveDisplay(sideLabel: l10n.sideCpu, move: cpuMove),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _outcomeText(l10n, outcome),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontFamily: 'serif',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
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
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(sideLabel, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(_emojiFor(move), style: const TextStyle(fontSize: 56)),
        const SizedBox(height: 4),
        Text(_labelFor(l10n, move), style: theme.textTheme.titleMedium),
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
    final l10n = AppLocalizations.of(context);
    final total = history.length;
    final visible = history.reversed.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Divider(height: 32),
        Text(l10n.recentRounds, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.noRoundsYet,
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
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            alignment: Alignment.center,
            child: Text(
              '$roundNumber',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${_emojiFor(record.playerMove)} ${_labelFor(l10n, record.playerMove)}'
              '  vs  '
              '${_emojiFor(record.cpuMove)} ${_labelFor(l10n, record.cpuMove)}',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _outcomeText(l10n, record.outcome),
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

String _labelFor(AppLocalizations l10n, MoveChoice move) {
  return switch (move) {
    MoveChoice.rock => l10n.moveRock,
    MoveChoice.paper => l10n.movePaper,
    MoveChoice.scissors => l10n.moveScissors,
  };
}

String _outcomeText(AppLocalizations l10n, RoundOutcome outcome) {
  return switch (outcome) {
    RoundOutcome.playerWin => l10n.outcomePlayerWin,
    RoundOutcome.cpuWin => l10n.outcomeCpuWin,
    RoundOutcome.tie => l10n.outcomeTie,
  };
}

Color _outcomeColor(ThemeData theme, RoundOutcome outcome) {
  return switch (outcome) {
    RoundOutcome.playerWin => theme.colorScheme.primary,
    RoundOutcome.cpuWin => theme.colorScheme.error,
    RoundOutcome.tie => theme.colorScheme.onSurfaceVariant,
  };
}
