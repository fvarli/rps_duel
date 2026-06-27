import 'package:flutter/material.dart';

import 'package:rps_duel/domain/cpu_difficulty.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';
import 'package:rps_duel/ui/game/difficulty_picker_sheet.dart';

Future<void> showSettingsSheet(
  BuildContext context, {
  required CpuDifficulty currentDifficulty,
  required bool soundEnabled,
  required ValueChanged<bool> onSoundChanged,
  required VoidCallback onDifficulty,
  required VoidCallback onLanguage,
  required VoidCallback onResetData,
  required VoidCallback onAbout,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      // Sound toggles live-in-sheet so the switch reflects the new value
      // immediately without closing the sheet; the parent persists.
      var localSound = soundEnabled;
      return StatefulBuilder(
        builder: (statefulCtx, setSheetState) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                    child: Text(
                      l10n.settingsTitle,
                      style: Theme.of(statefulCtx).textTheme.titleMedium,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.smart_toy),
                    title: Text(l10n.difficultyPickerTitle),
                    subtitle: Text(difficultyLabel(l10n, currentDifficulty)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(statefulCtx).pop();
                      onDifficulty();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(l10n.languagePickerTitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(statefulCtx).pop();
                      onLanguage();
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.volume_up),
                    title: Text(l10n.settingsSound),
                    value: localSound,
                    onChanged: (next) {
                      setSheetState(() => localSound = next);
                      onSoundChanged(next);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.restart_alt),
                    title: Text(l10n.settingsResetData),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(statefulCtx).pop();
                      onResetData();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l10n.settingsAbout),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(statefulCtx).pop();
                      onAbout();
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
