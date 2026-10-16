import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Global Enterprise Typography System for LifeUse.
/// File: lib/core/theme/app_typography.dart
///
/// Built strictly around the official LifeUse platform typography:
/// - Core Font Family: Inter (Universal Design Standard)
/// - Input Field Labels: Inter 13.5px, SemiBold (w600), color #4D4D4D (--Base-base-700)
/// - Type Scale: Display (56px), H1 (36px), H2 (28px), H3 (20px), H4 (17px),
///   Body (15px), BodySm (13px), Caption (12px), Overline (11px)
/// - Table Header: Inter 11px, Bold (w700), color #333333
/// - Table Cell: Inter 12px, SemiBold (w600), color #4D4D4D
class AppTypography {
  AppTypography._();

  /// Primary Universal Font Family: Inter (LifeUse Standard)
  static String get fontFamily => GoogleFonts.inter().fontFamily!;

  // ---------------------------------------------------------------------------
  // TEXT THEMES FOR LIGHT & DARK MODES
  // ---------------------------------------------------------------------------

  static TextTheme buildTextTheme({required bool isDark}) {
    final primaryColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return TextTheme(
      // Display / Big Metrics (Figma Type Scale: .t-display / 56px, line-height 62px)
      displayLarge: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: primaryColor,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: primaryColor,
      ),

      // Headlines (.t-h1 36px, .t-h2 28px, .t-h3 20px)
      headlineLarge: GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: primaryColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: primaryColor,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: primaryColor,
      ),

      // Titles & Sections (.t-h4 17px)
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: primaryColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),

      // Body Copy (.t-body 15px, .t-body-sm 13px)
      bodyLarge: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        height: 1.45,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.35,
      ),

      // Labels & Buttons (Common Action Buttons: Inter 14px/12px w700 / w600)
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        color: primaryColor,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LIFEUSE DESIGN SYSTEM TYPE SCALE HELPERS
  // ---------------------------------------------------------------------------

  /// .t-display { font-size: 56px; line-height: 62px; font-weight: 700; letter-spacing: -0.02em; }
  static TextStyle tDisplay({Color? color}) => GoogleFonts.inter(
        fontSize: 56,
        height: 62 / 56,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.12,
        color: color,
      );

  /// .t-h1 { font-size: 36px; line-height: 42px; font-weight: 700; letter-spacing: -0.015em; }
  static TextStyle tH1({Color? color}) => GoogleFonts.inter(
        fontSize: 36,
        height: 42 / 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.54,
        color: color,
      );

  /// .t-h2 { font-size: 28px; line-height: 34px; font-weight: 700; letter-spacing: -0.01em; }
  static TextStyle tH2({Color? color}) => GoogleFonts.inter(
        fontSize: 28,
        height: 34 / 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.28,
        color: color,
      );

  /// .t-h3 { font-size: 20px; line-height: 28px; font-weight: 600; letter-spacing: -0.005em; }
  static TextStyle tH3({Color? color}) => GoogleFonts.inter(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: color,
      );

  /// .t-h4 { font-size: 17px; line-height: 24px; font-weight: 600; }
  static TextStyle tH4({Color? color}) => GoogleFonts.inter(
        fontSize: 17,
        height: 24 / 17,
        fontWeight: FontWeight.w600,
        color: color,
      );

  /// .t-body { font-size: 15px; line-height: 22px; font-weight: 400; }
  static TextStyle tBody({Color? color}) => GoogleFonts.inter(
        fontSize: 15,
        height: 22 / 15,
        fontWeight: FontWeight.w400,
        color: color,
      );

  /// .t-body-sm { font-size: 13px; line-height: 18px; font-weight: 400; }
  static TextStyle tBodySm({Color? color}) => GoogleFonts.inter(
        fontSize: 13,
        height: 18 / 13,
        fontWeight: FontWeight.w400,
        color: color,
      );

  /// .t-caption { font-size: 12px; line-height: 16px; font-weight: 500; }
  static TextStyle tCaption({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        color: color,
      );

  /// .t-overline { font-size: 11px; line-height: 14px; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; }
  static TextStyle tOverline({Color? color}) => GoogleFonts.inter(
        fontSize: 11,
        height: 14 / 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.88,
        color: color,
      );

  // ---------------------------------------------------------------------------
  // FIGMA FORM FIELD & REUSABLE COMPONENT STYLES
  // ---------------------------------------------------------------------------

  /// Field label matching user's image ("Phone number", Inter, SemiBold 600, 13.5px)
  /// Color: #4D4D4D (Light Mode --Base-base-700) / #E6E6E6 (Dark Mode)
  static TextStyle inputLabel(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 13.5,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.05,
      color: AppColors.inputLabelOf(context),
    );
  }

  /// Input placeholder/hint text (Inter, Regular 400, 14px)
  static TextStyle inputHint(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondaryOf(context).withValues(alpha: 0.65),
    );
  }

  /// Input text value (Inter, Regular 400, 15px)
  static TextStyle inputValue(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimaryOf(context),
    );
  }

  /// Table header cell (Inter 11px Bold 700, #333333 / #CCCCCC)
  static TextStyle tableHeader({required bool isDark}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 20 / 11,
        color: isDark ? AppColors.darkBase800 : AppColors.base800,
      );

  /// Table body cell (Inter 12px SemiBold 600, #4D4D4D / #E6E6E6)
  static TextStyle tableCell({required bool isDark}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 20 / 12,
        color: isDark ? AppColors.darkBase700 : AppColors.base700,
      );

  /// Large Metric Stat Number (e.g., "271", "217")
  static TextStyle metricNumber({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.8,
      color: color,
    );
  }

  /// Counter Badge (e.g. "86", "2", "4")
  static TextStyle counterBadge({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: color ?? Colors.white,
    );
  }

  /// Adaptive fontSize calculation clamped to prevent UI overflow on large phone text settings
  static double adaptiveSize(BuildContext context, double baseSize,
      {double maxScale = 1.25}) {
    final scale = MediaQuery.textScalerOf(context).scale(1.0);
    final clampedScale = scale.clamp(0.85, maxScale);
    return baseSize * clampedScale;
  }
}
