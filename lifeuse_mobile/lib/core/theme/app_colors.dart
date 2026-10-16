import 'package:flutter/material.dart';

/// Centralized Global Color Palette extracted directly from the LifeUse design system
/// (global design tokens) and LifeUse platform theme.
/// File: lib/core/theme/app_colors.dart
class AppColors {
  AppColors._();

  // ===========================================================================
  // 1. LIFEUSE BASE TOKENS (from global token specification)
  // ===========================================================================
  static const Color base0 = Color(0xFFFFFFFF);
  static const Color base50 = Color(0xFFFAFAFA);
  static const Color base100 = Color(0xFFE6E6E6);
  static const Color base700 = Color(0xFF4D4D4D); // Used for Input field labels
  static const Color base800 = Color(0xFF333333);

  // Dark Mode Base tokens
  static const Color darkBase0 = Color(0xFF1A1A1A);
  static const Color darkBase50 = Color(0xFF1F1F1F);
  static const Color darkBase100 = Color(0xFF333333);
  static const Color darkBase700 = Color(0xFFE6E6E6);
  static const Color darkBase800 = Color(0xFFCCCCCC);

  // ===========================================================================
  // 2. PRIMARY VIOLET & PURPLE TOKENS
  // ===========================================================================
  static const Color primary = Color(0xFFA855F7); // LifeUse Vibrant Purple
  static const Color primaryDark = Color(0xFF8B5CF6);
  static const Color primaryDeep = Color(0xFF7C3AED);
  static const Color primaryViolet = Color(0xFFAE61F9);
  static const Color purple400 = Color(0xFFC084FC);
  static const Color purple425 = Color(0xFFB978FA);
  static const Color primaryLight = purple400;
  static const Color primaryGlow = Color(0x4DA855F7);
  static const Color primarySubtle = Color(0x1AA855F7);

  // ===========================================================================
  // 3. LIFEUSE INK SCALE
  // ===========================================================================
  static const Color ink50 = Color(0xFFFAFAFA);
  static const Color ink100 = Color(0xFFF4F5F5);
  static const Color ink200 = Color(0xFFE8E9E9);
  static const Color ink300 = Color(0xFFD1D3D3);
  static const Color ink400 = Color(0xFF9DA1A1);
  static const Color ink500 = Color(0xFF747A7A);
  static const Color ink600 = Color(0xFF545B5B);
  static const Color ink700 = Color(0xFF3D4343);
  static const Color ink800 = Color(0xFF282D2D);
  static const Color ink900 = Color(0xFF171B1B);
  static const Color ink950 = Color(0xFF0E1010);

  // ===========================================================================
  // 4. LIFEUSE BLUE SCALE
  // ===========================================================================
  static const Color bluebrand50 = Color(0xFFF0F7FF);
  static const Color bluebrand100 = Color(0xFFE0EFFF);
  static const Color bluebrand200 = Color(0xFFBAE6FD);
  static const Color bluebrand300 = Color(0xFF93C5FD);
  static const Color bluebrand400 = Color(0xFF60A5FA);
  static const Color bluebrand500 = Color(0xFF3B82F6);
  static const Color bluebrand600 = Color(0xFF2563EB);
  static const Color bluebrand700 = Color(0xFF1D4ED8);
  static const Color bluebrand800 = Color(0xFF1E40AF);
  static const Color bluebrand900 = Color(0xFF1E3A8A);

  // ===========================================================================
  // 5. LIFEUSE BRASS / ESTATE GREEN SCALE
  // ===========================================================================
  static const Color brass50 = Color(0xFFF0FDF4);
  static const Color brass100 = Color(0xFFDCFCE7);
  static const Color brass200 = Color(0xFFBBF7D0);
  static const Color brass300 = Color(0xFF86EFAC);
  static const Color brass400 = Color(0xFF4ADE80);
  static const Color brass500 = Color(0xFF22C55E);
  static const Color brass600 = Color(0xFF16A34A);
  static const Color brass700 = Color(0xFF15803D);
  static const Color brass800 = Color(0xFF166534);
  static const Color brass900 = Color(0xFF14532D);

  // ===========================================================================
  // 6. SECONDARY NEON ACCENTS (Cosmic energy theme compatibility)
  // ===========================================================================
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonCyanGlow = Color(0x4000E5FF);
  static const Color amberGold = Color(0xFFFFB800);
  static const Color amberGoldGlow = Color(0x40FFB800);

  // ===========================================================================
  // 7. SEMANTIC INTENTS (from global.css --success, --warning, --danger, --info)
  // ===========================================================================
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color successSubtle = Color(0x1A16A34A);

  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color errorSubtle = Color(0x1ADC2626);

  static const Color info = Color(0xFF2563EB);
  static const Color infoBg = Color(0xFFDBEAFE);

  // ===========================================================================
  // 8. SHADOW & ELEVATION TOKENS (from global.css)
  // ===========================================================================
  // --Shadowsshadow-base: rgba(128, 128, 128, 0.10);
  static const List<BoxShadow> shadowBase = [
    BoxShadow(
      color: Color(0x1A808080),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x0D09121B),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A09121B),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x1409121B),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0F09121B),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  // ===========================================================================
  // 9. THEME CONTAINER COLOR PALETTES
  // ===========================================================================
  static const Color darkBackground = Color(0xFF08090E);
  static const Color darkSurface = Color(0xFF121520);
  static const Color darkSurfaceElevated = Color(0xFF191E2C);
  static const Color darkBorder = Color(0xFF23283A);
  static const Color darkBorderActive = Color(0xFF383F58);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderActive = Color(0xFFCBD5E1);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextTertiary = Color(0xFF94A3B8);

  // Role Badges
  static const Color roleSuperAdmin = Color(0xFFA855F7);
  static const Color roleAdmin = Color(0xFF6366F1);
  static const Color roleCustomer = Color(0xFF06B6D4);
  static const Color roleUser = Color(0xFF10B981);

  // Aliases
  static const Color accent = neonCyan;
  static const Color accentLight = neonCyan;
  static const Color accentGold = amberGold;
  static const Color errorBackground = errorSubtle;
  static const Color successBackground = successSubtle;
  static const Color background = darkBackground;
  static const Color surface = darkSurface;
  static const Color surfaceElevated = darkSurfaceElevated;
  static const Color border = darkBorder;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textTertiary = darkTextTertiary;

  // Dynamic context helpers
  static Color backgroundOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBackground
          : lightBackground;

  static Color surfaceOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSurface
          : lightSurface;

  static Color borderOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBorder
          : lightBorder;

  static Color textPrimaryOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextPrimary
          : lightTextPrimary;

  static Color textSecondaryOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextSecondary
          : lightTextSecondary;

  static Color textTertiaryOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextTertiary
          : lightTextTertiary;

  /// Input label color: #4D4D4D in Light, #E6E6E6 in Dark (Matches user uploaded image)
  static Color inputLabelOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBase700 : base700;
}
