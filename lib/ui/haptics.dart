import 'package:flutter/services.dart';

class Haptics {
  Haptics._();

  static void tap() {
    HapticFeedback.lightImpact();
  }

  static void win() {
    HapticFeedback.mediumImpact();
  }

  static void loss() {
    HapticFeedback.selectionClick();
  }

  static void tie() {
    HapticFeedback.selectionClick();
  }
}
