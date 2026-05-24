import 'package:flutter/material.dart';

import 'package:rps_duel/generated/l10n/app_localizations.dart';

const List<({Locale locale, String nativeName})> _supported = [
  (locale: Locale('en'), nativeName: 'English'),
  (locale: Locale('tr'), nativeName: 'Türkçe'),
  (locale: Locale('es'), nativeName: 'Español'),
];

Future<void> showLanguagePicker(
  BuildContext context,
  ValueNotifier<Locale?> controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      final current = controller.value?.languageCode;
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                l10n.languagePickerTitle,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            for (final entry in _supported)
              ListTile(
                title: Text(entry.nativeName),
                trailing: current == entry.locale.languageCode
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  controller.value = entry.locale;
                  Navigator.of(ctx).pop();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
