import 'package:flutter/widgets.dart';

class LocaleScope extends InheritedNotifier<ValueNotifier<Locale?>> {
  const LocaleScope({
    super.key,
    required ValueNotifier<Locale?> controller,
    required super.child,
  }) : super(notifier: controller);

  static ValueNotifier<Locale?> of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'No LocaleScope found in widget tree');
    return scope!.notifier!;
  }
}
