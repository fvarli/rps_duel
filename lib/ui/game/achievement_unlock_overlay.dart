import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:rps_duel/domain/achievement.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/achievements_card.dart' show achievementTitle;
import 'package:rps_duel/ui/haptics.dart';
import 'package:rps_duel/ui/theme/tactile_theme.dart';

const Duration _enterDuration = Duration(milliseconds: 280);
const Duration _holdDuration = Duration(milliseconds: 2400);
const Duration _exitDuration = Duration(milliseconds: 280);
const double _slideTravel = 64.0;

/// Floating, auto-dismissed toast that announces an achievement unlock.
///
/// Queued: if multiple achievements unlock in the same round they cascade
/// one after another in enum-index order — no stacking, no missed unlocks.
/// Lifetime is entirely owned by this class; the game screen only enqueues.
class AchievementUnlockOverlay {
  AchievementUnlockOverlay._();

  static final Queue<AchievementId> _queue = Queue<AchievementId>();
  static bool _showing = false;
  static OverlayState? _overlay;

  /// Enqueue an unlock toast. Safe to call multiple times in the same frame.
  static void enqueue(BuildContext context, AchievementId id) {
    _queue.add(id);
    _overlay ??= Overlay.maybeOf(context, rootOverlay: true);
    _maybeShowNext();
  }

  /// Clear queue + active toast without animation. Test-only.
  @visibleForTesting
  static void debugReset() {
    _queue.clear();
    _showing = false;
    _overlay = null;
  }

  static void _maybeShowNext() {
    if (_showing) return;
    if (_queue.isEmpty) return;
    final overlay = _overlay;
    if (overlay == null || !overlay.mounted) {
      _overlay = null;
      _queue.clear();
      return;
    }

    final id = _queue.removeFirst();
    _showing = true;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _AchievementUnlockToast(
        id: id,
        onDismissed: () {
          entry.remove();
          _showing = false;
          _maybeShowNext();
        },
      ),
    );
    overlay.insert(entry);
  }
}

class _AchievementUnlockToast extends StatefulWidget {
  const _AchievementUnlockToast({
    required this.id,
    required this.onDismissed,
  });

  final AchievementId id;
  final VoidCallback onDismissed;

  @override
  State<_AchievementUnlockToast> createState() =>
      _AchievementUnlockToastState();
}

class _AchievementUnlockToastState extends State<_AchievementUnlockToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slide;
  late final Animation<double> _fade;
  Timer? _holdTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _enterDuration,
      reverseDuration: _exitDuration,
    );
    _slide = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    Haptics.unlock();
    _controller.forward().whenComplete(_startHold);
  }

  void _startHold() {
    if (!mounted) return;
    _holdTimer = Timer(_holdDuration, _startExit);
  }

  void _startExit() {
    if (!mounted) return;
    _controller.reverse().whenComplete(_finish);
  }

  void _finish() {
    if (!mounted) return;
    widget.onDismissed();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.only(top: 12),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (ctx, child) {
                final dy = (1 - _slide.value) * -_slideTravel;
                return Opacity(
                  opacity: _fade.value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, dy),
                    child: child,
                  ),
                );
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: _UnlockCard(
                  header: l10n.achievementUnlocked,
                  title: achievementTitle(l10n, widget.id),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UnlockCard extends StatelessWidget {
  const _UnlockCard({required this.header, required this.title});

  final String header;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outline),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: TactileColors.shadowInk10,
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(width: 4, color: TactileColors.sage),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          header,
                          style: const TextStyle(
                            color: TactileColors.sage,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
