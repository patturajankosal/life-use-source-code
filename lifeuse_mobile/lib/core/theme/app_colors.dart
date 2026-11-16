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
  // 2. PRIMARY PURPLE (AMETHYST PURPLE & OLED TRUE BLACK SYSTEM)
  // Light: Deepened Amethyst Purple #7F35AD (increased darkness for rich contrast)
  // Dark: OLED True Black with Amethyst Violet Accents #C79BEF / #9B4DCA
  // ===========================================================================
  static const Color primary =
      Color(0xFF7F35AD); // Deepened Amethyst Purple #7F35AD (Light Mode)
  static const Color primaryDark =
      Color(0xFF6A2A92); // Button Pressed / Deep Accent #6A2A92
  static const Color primaryDeep = Color(0xFF541C7A); // Midnight Violet #541C7A
  static const Color primaryLight =
      Color(0xFFA05DCB); // Secondary Purple #A05DCB
  static const Color softLavender =
      Color(0xFFF5ECFA); // Tonal Purple / Selected #F5ECFA
  static const Color secondarySurface =
      Color(0xFFFBFAFC); // Page Background #FBFAFC
  static const Color primaryGlow = Color(0x337F35AD); // Purple subtle glow
  static const Color primarySubtle = Color(0x1A7F35AD); // 10% Purple tint
  static const Color primaryViolet = Color(0xFF7F35AD);
  static const Color purple400 = Color(0xFFA05DCB);
  static const Color purple425 = Color(0xFF8A3FB8);

  // OLED True Black Dark Mode Palette Tokens
  static const Color darkAccent = Color(0xFFC79BEF); // OLED Accent #C79BEF
  static const Color darkButton = Color(0xFF9B4DCA); // OLED Button #9B4DCA
  static const Color darkButtonPressed =
      Color(0xFFAE63DD); // OLED Pressed #AE63DD
  static const Color darkSecondary =
      Color(0xFFB57EE0); // OLED Secondary #B57EE0
  static const Color darkTonal = Color(0xFF2A1838); // OLED Tonal #2A1838
  static const Color darkBadgeBg = Color(0xFF2E1A40); // OLED Badge Bg #2E1A40
  static const Color darkBadgeText =
      Color(0xFFDDB8F7); // OLED Badge Text #DDB8F7

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
  // 9. MINIMAL PREMIUM COLOR PALETTES (ChatGPT-Inspired Neutral Foundation)
  // Pure White + Black Icons (Light) | Premium Black + White Icons (Dark)
  // Signature LifeUse Purple strictly for CTAs & important highlights
  // ===========================================================================
  // Dark Mode Palette (Near Black / Dark Neutral)
  static const Color darkBackground =
      Color(0xFF121212); // Premium Near-Black #121212
  static const Color darkSurface =
      Color(0xFF1E1E1E); // Neutral Dark Surface #1E1E1E
  static const Color darkSurfaceElevated =
      Color(0xFF262626); // Elevated Neutral Sheet #262626
  static const Color darkBorder =
      Color(0xFF2E2E2E); // Subtle Neutral Border #2E2E2E
  static const Color darkBorderActive = Color(0xFF3F3F46);
  static const Color darkTextPrimary =
      Color(0xFFFFFFFF); // Heading & Primary Text #FFFFFF
  static const Color darkTextSecondary =
      Color(0xFFA1A1AA); // Light Grey Body Text #A1A1AA
  static const Color darkTextTertiary =
      Color(0xFF71717A); // Medium Grey Supporting Text #71717A
  static const Color darkIcon =
      Color(0xFFFFFFFF); // Clean White Neutral Icon #FFFFFF
  static const Color darkNav =
      Color(0xFF181818); // Neutral Dark Bottom Nav #181818
  static const Color darkInput =
      Color(0xFF1E1E1E); // Neutral Input Background #1E1E1E

  // Light Mode Palette (ChatGPT-Inspired Minimal Pure White)
  static const Color lightBackground =
      Color(0xFFFFFFFF); // Pure White Background #FFFFFF
  static const Color lightSurface =
      Color(0xFFFFFFFF); // Pure White Card Surface #FFFFFF
  static const Color lightSurfaceElevated =
      Color(0xFFFFFFFF); // Elevated Surface #FFFFFF
  static const Color lightSurfaceSecondary =
      Color(0xFFF7F7F8); // Minimal Neutral Grey Secondary Surface #F7F7F8
  static const Color lightBorder =
      Color(0xFFE5E5E5); // Clean Neutral Border #E5E5E5
  static const Color lightBorderActive = Color(0xFFD4D4D8);
  static const Color lightTextPrimary =
      Color(0xFF111111); // Crisp Black Heading & Primary Text #111111
  static const Color lightTextSecondary =
      Color(0xFF666666); // Neutral Grey Body Text #666666
  static const Color lightTextTertiary =
      Color(0xFF8E8E93); // Medium Grey Supporting Text #8E8E93
  static const Color lightIcon =
      Color(0xFF111111); // Crisp Black / Neutral Icon #111111
  static const Color lightNav =
      Color(0xFFFFFFFF); // Pure White Bottom Nav #FFFFFF
  static const Color lightInput =
      Color(0xFFFFFFFF); // Pure White Input Background #FFFFFF
  static const Color lightInputFill =
      Color(0xFFF7F7F8); // Neutral Input Fill #F7F7F8

  // M3 Tonal Containers & Accents
  static const Color primaryContainer =
      Color(0xFFF7F7F8); // Minimal Neutral Container
  static const Color secondaryIndigo =
      Color(0xFF6A2A92); // Button Pressed #6A2A92
  static const Color secondaryIndigoContainer = Color(0xFFF7F7F8);
  static const Color tertiaryAmber =
      Color(0xFFF59E0B); // Deadlines & budget warnings
  static const Color tertiaryAmberContainer = Color(0x1FF59E0B);

  // Financial Semantics (Status only - retained for ledger clarity)
  static const Color financialPositive = Color(0xFF10B981); // Inflow & Income
  static const Color financialNegative =
      Color(0xFFEF4444); // Outflow & Expenses
  static const Color financialWarning = Color(0xFFF59E0B); // Budget caution

  // Role Badges
  static const Color roleSuperAdmin = Color(0xFF7F35AD);
  static const Color roleAdmin = Color(0xFF6A2A92);
  static const Color roleCustomer = Color(0xFFA05DCB);
  static const Color roleUser = Color(0xFF7F35AD);

  // Aliases
  static const Color accent = primary;
  static const Color accentLight = primaryLight;
  static const Color accentGold = amberGold;
  static const Color errorBackground = errorSubtle;
  static const Color successBackground = successSubtle;
  static const Color background = lightBackground;
  static const Color surface = lightSurface;
  static const Color surfaceElevated = lightSurfaceElevated;
  static const Color border = lightBorder;
  static const Color textPrimary = lightTextPrimary;
  static const Color textSecondary = lightTextSecondary;
  static const Color textTertiary = lightTextTertiary;

  // Dynamic context helpers
  static Color backgroundOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBackground
          : lightBackground;

  static Color surfaceOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSurface
          : lightSurface;

  static Color surfaceSecondaryOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSurfaceElevated
          : lightSurfaceSecondary;

  static Color surfaceElevatedOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSurfaceElevated
          : lightSurfaceElevated;

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

  static Color iconOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkIcon : lightIcon;

  static Color primaryOf(BuildContext context) => primary;

  static Color primaryContainerOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF262626)
          : const Color(0xFFF4F4F5);

  static Color inactiveIconOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF71717A)
          : const Color(0xFF8E8E93);

  static Color badgeBgOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF262626)
          : const Color(0xFFF4F4F5);

  static Color badgeTextOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextPrimary
          : lightTextPrimary;

  /// Input label color: #4D4D4D in Light, #E6E6E6 in Dark
  static Color inputLabelOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBase700 : base700;

  // ===========================================================================
  // 10. UNIFIED ICON COLOR TOKENS (AIRIX & JioCare Minimal System)
  // Light: LifeUse Dark Purple (#7F35AD) icon on very light lavender (#F5ECFA)
  // Dark: White (#FFFFFF) icon on subtle dark purple surface (#261933)
  // ===========================================================================
  static const Color iconLightBackground = Color(0xFFF5ECFA);
  static const Color iconLightBorder = Color(0xFFEBE0F5);
  static const Color iconDarkBackground = Color(0xFF261933);
  static const Color iconDarkBorder = Color(0xFF3D2550);

  /// Unified Brand Icon color: LifeUse Dark Purple (#7F35AD) in Light Mode, White in Dark Mode.
  static Color brandIconOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.white : primary;

  /// Unified Icon Background surface: Very light lavender (#F5ECFA) in Light Mode,
  /// subtle dark purple surface (#261933) in Dark Mode.
  static Color iconBackgroundOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? iconDarkBackground
          : iconLightBackground;

  /// Unified Icon Container Border: Subtle border in Light & Dark modes.
  static Color iconBorderOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? iconDarkBorder
          : iconLightBorder;
}
