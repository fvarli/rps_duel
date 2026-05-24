import 'package:flutter/material.dart';

/// Tactile Premium palette — warm cream paper with ink text and sage/clay
/// state accents. Extracted from docs/concepts/concept4.jsx + shared.jsx.
class TactileColors {
  const TactileColors._();

  // Surfaces
  static const Color background = Color(0xFFF0E9D8);
  static const Color backgroundWarm = Color(0xFFEBE3CF);
  static const Color surface = Color(0xFFFBF7EC);
  static const Color paperEdge = Color(0xFFE0D6BD);

  // Hairlines / dividers
  static const Color hairline = Color(0xFFD8D0B8);
  static const Color hairlineSoft = Color(0xFFE6DFCA);

  // Ink (text)
  static const Color ink = Color(0xFF1F1C14);
  static const Color inkSoft = Color(0xFF5A5443);
  static const Color inkMuted = Color(0xFF8E8772);
  static const Color inkFaint = Color(0xFFBDB6A0);

  // State accents
  static const Color sage = Color(0xFF5C7D44); // player win, achievement
  static const Color clay = Color(0xFFA85A3B); // cpu win
  static const Color gold = Color(0xFFB8862A); // achievement gold accent

  // Soft drop shadow used on most surfaces.
  static const Color shadowInk10 = Color.fromRGBO(31, 28, 20, 0.10);
}

/// Build the single Tactile Premium [ThemeData] applied app-wide.
///
/// Not a theme engine — one theme, baked in. ThemePack runtime swap is
/// deferred to a future phase per the original handoff plan.
ThemeData tactileTheme() {
  final colorScheme = const ColorScheme.light().copyWith(
    primary: TactileColors.sage,
    onPrimary: Colors.white,
    error: TactileColors.clay,
    onError: Colors.white,
    surface: TactileColors.surface,
    onSurface: TactileColors.ink,
    surfaceContainerHighest: TactileColors.surface,
    onSurfaceVariant: TactileColors.inkSoft,
    outline: TactileColors.hairline,
    outlineVariant: TactileColors.hairlineSoft,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: TactileColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: TactileColors.background,
      foregroundColor: TactileColors.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: TactileColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: TactileColors.hairline, width: 1),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: TactileColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: TactileColors.hairline, width: 1),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: TactileColors.surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: TactileColors.surface,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: TactileColors.inkSoft,
    ),
    dividerTheme: const DividerThemeData(
      color: TactileColors.hairlineSoft,
      thickness: 1,
      space: 1,
    ),
  );
}
