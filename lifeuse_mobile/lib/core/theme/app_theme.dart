import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

export 'app_fonts.dart';

/// Centralized Minimal Premium ThemeData definitions for Light & Dark Mode.
/// Inspired by ChatGPT's clean, minimal aesthetic:
/// - Pure White (#FFFFFF) in Light Mode, Near-Black (#121212) in Dark Mode
/// - Black / Dark Neutral icons in Light Mode, White / Light Neutral icons in Dark Mode
/// - Signature LifeUse Purple (#7F35AD) reserved strictly for CTAs & highlights
/// File: lib/core/theme/app_theme.dart
class AppTheme {
  AppTheme._();

  // ===========================================================================
  // DARK THEME (Near-Black Neutral Minimal)
  // ===========================================================================
  static ThemeData get darkTheme {
    final textTheme = AppTypography.buildTextTheme(isDark: true);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.primary,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: Color(0xFF262626),
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkTextPrimary,
          size: 24,
          shadows: [
            Shadow(
              color: Color(0x59FFFFFF),
              blurRadius: 0.6,
            ),
          ],
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkIcon,
        size: 24,
        shadows: [
          Shadow(
            color: Color(0x59FFFFFF),
            blurRadius: 0.6,
          ),
        ],
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.darkTextTertiary,
        ),
        prefixIconColor: AppColors.darkIcon,
        suffixIconColor: AppColors.darkTextSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
      ),
    );
  }

  // ===========================================================================
  // LIGHT THEME (ChatGPT-Inspired Pure White Minimal)
  // ===========================================================================
  static ThemeData get lightTheme {
    final textTheme = AppTypography.buildTextTheme(isDark: false);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      primaryColor: AppColors.primary,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: Color(0xFFF7F7F8),
        surface: AppColors.lightSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.lightTextPrimary,
          size: 24,
          shadows: [
            Shadow(
              color: Color(0x40111111),
              blurRadius: 0.6,
            ),
          ],
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightIcon,
        size: 24,
        shadows: [
          Shadow(
            color: Color(0x40111111),
            blurRadius: 0.6,
          ),
        ],
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceSecondary,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.lightTextSecondary,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.lightTextTertiary,
        ),
        prefixIconColor: AppColors.lightIcon,
        suffixIconColor: AppColors.lightTextSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
      ),
    );
  }
}
