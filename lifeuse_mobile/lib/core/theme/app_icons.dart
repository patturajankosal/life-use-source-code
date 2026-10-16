import 'package:flutter/material.dart';

/// Centralized Global Iconography registry for LifeUse.
/// File: lib/core/theme/app_icons.dart
///
/// Contains all icons mapped directly from the Figma Design System
/// including Auth, Navigation, Platform Sidebar, and Dashboard Metrics.
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
  static const IconData email = Icons.mail_outline_rounded;
  static const IconData phone = Icons.phone_iphone_rounded;
  static const IconData username = Icons.alternate_email_rounded;
  static const IconData userProfile = Icons.person_outline_rounded;
  static const IconData password = Icons.lock_outline_rounded;
  static const IconData passwordVisible = Icons.visibility_outlined;
  static const IconData passwordHidden = Icons.visibility_off_outlined;

  // ---------------------------------------------------------------------------
  // 3. FIGMA PLATFORM & SIDEBAR NAVIGATION (Directly from Figma UI specs)
  // ---------------------------------------------------------------------------
  static const IconData dashboard = Icons.grid_view_rounded;
  static const IconData staff = Icons.people_outline_rounded;
  static const IconData targetTracking = Icons.track_changes_rounded;
  static const IconData orgChart = Icons.account_tree_outlined;
  static const IconData attendance = Icons.calendar_today_outlined;
  static const IconData attendanceApproval = Icons.event_available_outlined;
  static const IconData travelAllowance = Icons.directions_car_outlined;
  static const IconData leaves = Icons.date_range_outlined;
  static const IconData permission = Icons.schedule_outlined;
  static const IconData workFromHome = Icons.home_outlined;
  static const IconData hiring = Icons.person_search_outlined;
  static const IconData salarySlip = Icons.receipt_long_outlined;
  static const IconData fineAndDeduction = Icons.bookmark_border_rounded;
  static const IconData incentives = Icons.card_giftcard_outlined;
  static const IconData backToWorkspace = Icons.chevron_left_rounded;

  // ---------------------------------------------------------------------------
  // 4. NAVIGATION, THEME & SYSTEM ACTIONS
  // ---------------------------------------------------------------------------
  static const IconData arrowBack = Icons.arrow_back_ios_new_rounded;
  static const IconData arrowForward = Icons.arrow_forward_rounded;
  static const IconData chevronDown = Icons.keyboard_arrow_down_rounded;
  static const IconData logout = Icons.logout_rounded;
  static const IconData settings = Icons.settings_outlined;
  static const IconData darkMode = Icons.dark_mode_rounded;
  static const IconData lightMode = Icons.light_mode_rounded;

  // ---------------------------------------------------------------------------
  // 5. STATUS, TRENDS & FEEDBACK
  // ---------------------------------------------------------------------------
  static const IconData checkCircle = Icons.check_circle_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData errorCircle = Icons.error_outline_rounded;
  static const IconData warningAlert = Icons.warning_amber_rounded;
  static const IconData pending = Icons.pending_outlined;
  static const IconData badge = Icons.badge_outlined;
  static const IconData trendUp = Icons.trending_up_rounded;
}
