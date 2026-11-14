import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Centralized Global Iconography registry for LifeUse.
/// File: lib/core/theme/app_icons.dart
///
/// Contains all icons mapped directly from the Premium Minimal Design System
/// using modern Lucide outline iconography.
class AppIcons {
  AppIcons._();

  // ---------------------------------------------------------------------------
  // 1. BRAND ASSETS (Stored locally in assets/images/)
  // ---------------------------------------------------------------------------
  static const String brandIconAsset = 'assets/images/app_icon.png';
  static const String brandWordmarkAsset = 'assets/images/lifeuse_wordmark.png';

  // ---------------------------------------------------------------------------
  // 2. AUTHENTICATION & FORM ICONS
  // ---------------------------------------------------------------------------
  static const IconData email = LucideIcons.mail;
  static const IconData phone = LucideIcons.phone;
  static const IconData username = LucideIcons.atSign;
  static const IconData userProfile = LucideIcons.user;
  static const IconData password = LucideIcons.lock;
  static const IconData passwordVisible = LucideIcons.eye;
  static const IconData passwordHidden = LucideIcons.eyeOff;

  // ---------------------------------------------------------------------------
  // 3. FIGMA PLATFORM & SIDEBAR NAVIGATION (Directly from Figma UI specs)
  // ---------------------------------------------------------------------------
  static const IconData dashboard = LucideIcons.layoutDashboard;
  static const IconData staff = LucideIcons.userCheck;
  static const IconData targetTracking = LucideIcons.compass;
  static const IconData orgChart = LucideIcons.layoutGrid;
  static const IconData attendance = LucideIcons.checkSquare;
  static const IconData attendanceApproval = LucideIcons.checkCircle2;
  static const IconData travelAllowance = LucideIcons.plane;
  static const IconData leaves = LucideIcons.clock;
  static const IconData permission = LucideIcons.shieldCheck;
  static const IconData workFromHome = LucideIcons.home;
  static const IconData hiring = LucideIcons.user;
  static const IconData salarySlip = LucideIcons.receipt;
  static const IconData fineAndDeduction = LucideIcons.wallet;
  static const IconData incentives = LucideIcons.award;
  static const IconData backToWorkspace = LucideIcons.arrowLeft;

  // ---------------------------------------------------------------------------
  // 4. NAVIGATION, THEME & SYSTEM ACTIONS
  // ---------------------------------------------------------------------------
  static const IconData arrowBack = LucideIcons.arrowLeft;
  static const IconData arrowForward = LucideIcons.arrowRight;
  static const IconData chevronDown = LucideIcons.chevronDown;
  static const IconData logout = LucideIcons.logOut;
  static const IconData settings = LucideIcons.settings;
  static const IconData darkMode = LucideIcons.moon;
  static const IconData lightMode = LucideIcons.sun;

  // ---------------------------------------------------------------------------
  // 5. STATUS, TRENDS & FEEDBACK
  // ---------------------------------------------------------------------------
  static const IconData checkCircle = LucideIcons.checkCircle2;
  static const IconData check = LucideIcons.check;
  static const IconData errorCircle = LucideIcons.alertCircle;
  static const IconData warningAlert = LucideIcons.alertTriangle;
  static const IconData pending = LucideIcons.clock;
  static const IconData badge = LucideIcons.shieldCheck;
  static const IconData trendUp = LucideIcons.trendingUp;
}
