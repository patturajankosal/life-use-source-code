import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Global Enterprise Typography System for LifeUse.
/// File: lib/core/theme/app_typography.dart
///
/// Built around Google-Inspired Modern Minimal design architecture:
/// - Display, Headlines & Titles: Plus Jakarta Sans (Geometric humanist warmth matching Google Sans)
/// - Body Text, Forms & Financial Numbers: Inter with Tabular Figures for precision
class AppTypography {
  AppTypography._();

  /// Primary Display & Headline Font Family: Plus Jakarta Sans
  static String get headingFontFamily => GoogleFonts.plusJakartaSans().fontFamily!;

  /// Primary Body & Tabular Font Family: Inter
  static String get bodyFontFamily => GoogleFonts.inter().fontFamily!;

  // ---------------------------------------------------------------------------
  // TEXT THEMES FOR LIGHT & DARK MODES
  // ---------------------------------------------------------------------------

  static TextTheme buildTextTheme({required bool isDark}) {
    final primaryColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return TextTheme(
      // Display / Big Metrics (Plus Jakarta Sans)
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: primaryColor,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: primaryColor,
      ),

      // Headlines (Plus Jakarta Sans)
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: primaryColor,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: primaryColor,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: primaryColor,
      ),

      // Titles & Sections (Plus Jakarta Sans)
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: primaryColor,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: primaryColor,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),

      // Body Copy (Inter)
      bodyLarge: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        height: 1.45,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13.5,
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

      // Labels & Buttons (Plus Jakarta Sans)
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: primaryColor,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: primaryColor,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GOOGLE-INSPIRED DESIGN SYSTEM HELPERS
  // ---------------------------------------------------------------------------

  /// Financial Amount with Tabular Monospace Figures (+₹1,250.00 / -₹450.00)
  static TextStyle financialAmount({
    Color? color,
    double size = 16,
    FontWeight weight = FontWeight.w600,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: -0.2,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: color,
    );
  }

  /// Dashboard Main Greeting & Net Worth Metric
  static TextStyle dashboardHero({Color? color}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      color: color,
    );
  }

  /// Section Headings ("Life Modules", "Recent Activity")
  static TextStyle sectionHeading({Color? color}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: color,
    );
  }

  /// Screen Top App Bar Title
  static TextStyle screenTitle({Color? color}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: color,
    );
  }

  /// Card Titles (Module Name, Task Title)
  static TextStyle cardTitle({Color? color}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.1,
      color: color,
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
