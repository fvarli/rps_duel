import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rps_duel/app/locale_scope.dart';
import 'package:rps_duel/app/router.dart';
import 'package:rps_duel/data/local_locale_storage.dart';
import 'package:rps_duel/generated/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeStorage = await LocaleStorage.open();
  final localeController = ValueNotifier<Locale?>(localeStorage.load());
  localeController.addListener(() {
    unawaited(localeStorage.save(localeController.value));
  });
  runApp(
    LocaleScope(
      controller: localeController,
      child: ProviderScope(child: RpsDuelApp(localeController: localeController)),
    ),
  );
}

class RpsDuelApp extends ConsumerWidget {
  const RpsDuelApp({super.key, required this.localeController});

  final ValueNotifier<Locale?> localeController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: localeController,
      builder: (context, locale, _) => MaterialApp.router(
        title: 'RPS Duel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        locale: locale,
        routerConfig: appRouter,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
      ),
    );
  }
}
