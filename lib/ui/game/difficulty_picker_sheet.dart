import 'package:flutter/material.dart';

import 'package:rps_duel/domain/cpu_difficulty.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';

String difficultyLabel(AppLocalizations l10n, CpuDifficulty difficulty) {
  return switch (difficulty) {
    CpuDifficulty.easy => l10n.difficultyEasy,
    CpuDifficulty.normal => l10n.difficultyNormal,
    CpuDifficulty.hard => l10n.difficultyHard,
  };
}

Future<void> showDifficultyPicker(
  BuildContext context,
  CpuDifficulty current,
  ValueChanged<CpuDifficulty> onSelected,
) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                l10n.difficultyPickerTitle,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            for (final d in CpuDifficulty.values)
              ListTile(
                title: Text(difficultyLabel(l10n, d)),
                trailing: current == d ? const Icon(Icons.check) : null,
                onTap: () {
                  Navigator.of(ctx).pop();
                  onSelected(d);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
