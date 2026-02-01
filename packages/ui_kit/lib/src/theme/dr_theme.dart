import 'package:flutter/material.dart';
import 'package:ui_kit/src/foundation/foundation.dart';

abstract final class DRTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: DRTypography.fontFamily,
    colorScheme: ColorScheme.light(
      primary: DRColors.primary,
      secondary: DRColors.secondary,
      error: DRColors.error,
      surface: DRColors.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onSurface: DRColors.neutral.shade800,
    ),
    scaffoldBackgroundColor: DRColors.neutral.shade50,
    appBarTheme: AppBarTheme(
      backgroundColor: DRColors.surface,
      foregroundColor: DRColors.neutral.shade800,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: DRTypography.headlineSm.copyWith(
        color: DRColors.neutral.shade800,
      ),
    ),
    cardTheme: CardThemeData(
      color: DRColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: DRRadius.borderLg,
        side: BorderSide(color: DRColors.neutral.shade200),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: DRColors.neutral.shade200,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DRColors.surface,
      border: OutlineInputBorder(
        borderRadius: DRRadius.borderMd,
        borderSide: BorderSide(color: DRColors.neutral.shade200),
      ),
      contentPadding: const EdgeInsets.all(DRSpacing.inputPadding),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DRColors.surface,
      selectedItemColor: DRColors.primary,
      unselectedItemColor: DRColors.neutral.shade400,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: DRTypography.fontFamily,
    colorScheme: ColorScheme.dark(
      primary: DRColors.primaryLight,
      secondary: DRColors.secondaryLight,
      error: DRColors.error,
      surface: DRColors.surfaceDark,
      onPrimary: DRColors.neutral.shade900,
      onSecondary: DRColors.neutral.shade900,
      onError: Colors.white,
      onSurface: DRColors.neutral.shade100,
    ),
    scaffoldBackgroundColor: DRColors.backgroundDark,
    appBarTheme: AppBarTheme(
      backgroundColor: DRColors.surfaceDark,
      foregroundColor: DRColors.neutral.shade100,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: DRTypography.headlineSm.copyWith(
        color: DRColors.neutral.shade100,
      ),
    ),
    cardTheme: CardThemeData(
      color: DRColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: DRRadius.borderLg,
        side: BorderSide(color: DRColors.neutral.shade700),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: DRColors.neutral.shade700,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DRColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: DRRadius.borderMd,
        borderSide: BorderSide(color: DRColors.neutral.shade700),
      ),
      contentPadding: const EdgeInsets.all(DRSpacing.inputPadding),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DRColors.surfaceDark,
      selectedItemColor: DRColors.primaryLight,
      unselectedItemColor: DRColors.neutral.shade500,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
