import 'package:flutter/material.dart';

import 'package:rps_duel/generated/l10n/app_localizations.dart';

Future<void> showSettingsSheet(
  BuildContext context, {
  required VoidCallback onLanguage,
  required VoidCallback onResetData,
  required VoidCallback onAbout,
}) {
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
                l10n.settingsTitle,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.languagePickerTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(ctx).pop();
                onLanguage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: Text(l10n.settingsResetData),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(ctx).pop();
                onResetData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.settingsAbout),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(ctx).pop();
                onAbout();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
