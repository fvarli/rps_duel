import 'package:flutter/material.dart';

import 'package:rps_duel/ui/haptics.dart';

class MoveButton extends StatelessWidget {
  const MoveButton({
    super.key,
    required this.emoji,
    required this.label,
    required this.onPressed,
  });

  final String emoji;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onPressed == null;
    return SizedBox(
      height: 96,
      child: Opacity(
        opacity: disabled ? 0.45 : 1.0,
        child: FilledButton(
          onPressed: onPressed == null
              ? null
              : () {
                  Haptics.tap();
                  onPressed!();
                },
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
            disabledBackgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.onSurface,
            disabledForegroundColor: theme.colorScheme.onSurface,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.colorScheme.outline),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 4),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
