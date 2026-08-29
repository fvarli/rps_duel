import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Localization must stay complete for every supported locale. The three
/// ARB files drifted to 90/90/90 by hand discipline alone; this locks it
/// in so a future copy change cannot silently ship a missing string.
///
/// Only `en` carries `@key` metadata blocks, so those are excluded from
/// the comparison — we compare message keys only.
Set<String> _messageKeys(String path) {
  final raw = File(path).readAsStringSync();
  final map = json.decode(raw) as Map<String, dynamic>;
  return map.keys.where((k) => !k.startsWith('@')).toSet();
}

void main() {
  const en = 'lib/l10n/app_en.arb';
  const tr = 'lib/l10n/app_tr.arb';
  const es = 'lib/l10n/app_es.arb';

  group('ARB parity', () {
    test('every locale defines exactly the same message keys', () {
      final enKeys = _messageKeys(en);
      final trKeys = _messageKeys(tr);
      final esKeys = _messageKeys(es);

      expect(
        enKeys.difference(trKeys),
        isEmpty,
        reason: 'Keys present in en but missing from tr',
      );
      expect(
        trKeys.difference(enKeys),
        isEmpty,
        reason: 'Keys present in tr but missing from en',
      );
      expect(
        enKeys.difference(esKeys),
        isEmpty,
        reason: 'Keys present in en but missing from es',
      );
      expect(
        esKeys.difference(enKeys),
        isEmpty,
        reason: 'Keys present in es but missing from en',
      );
    });

    test('no locale ships an empty translation', () {
      for (final path in <String>[en, tr, es]) {
        final map =
            json.decode(File(path).readAsStringSync()) as Map<String, dynamic>;
        for (final entry in map.entries) {
          if (entry.key.startsWith('@')) continue;
          expect(
            (entry.value as String).trim(),
            isNotEmpty,
            reason: '$path has an empty value for "${entry.key}"',
          );
        }
      }
    });
  });
}
