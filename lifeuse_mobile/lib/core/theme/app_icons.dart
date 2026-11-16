import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Centralized Global Iconography registry for LifeUse.
/// File: lib/core/theme/app_icons.dart
///
/// Contains all icons mapped directly from the Premium Minimal Design System
/// and AIRIX One Design System reference:
/// - 2.0px stroke rounded outline base
/// - Filled pairs for active navigation states
/// - Duotone pastel badges for modules & quick actions
/// - Selective soft 3D tokens for hero states
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
  // 3. FIGMA PLATFORM & SIDEBAR NAVIGATION (Preserved 1-to-1)
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

  // ---------------------------------------------------------------------------
  // 6. CORE 5-DESTINATION NAVIGATION (OUTLINE & FILLED PAIRS)
  // ---------------------------------------------------------------------------
  static const IconData homeOutline = LucideIcons.home;
  static const IconData homeFilled = LucideIcons.home;
  static const IconData modulesOutline = LucideIcons.layoutGrid;
  static const IconData modulesFilled = LucideIcons.layoutGrid;
  static const IconData activityOutline = LucideIcons.activity;
  static const IconData activityFilled = LucideIcons.activity;
  static const IconData alertsOutline = LucideIcons.bell;
  static const IconData alertsFilled = LucideIcons.bellRing;
  static const IconData profileOutline = LucideIcons.user;
  static const IconData profileFilled = LucideIcons.userCheck;

  // ---------------------------------------------------------------------------
  // 7. QUICK ACTIONS & FINANCIAL ICONS (AIRIX ACTIONS AUDITED)
  // ---------------------------------------------------------------------------
  static const IconData addExpense = LucideIcons.plus;
  static const IconData transfer = LucideIcons.arrowUpRight;
  static const IconData scanReceipt = LucideIcons.scanLine;
  static const IconData payDues = LucideIcons.receipt;
  static const IconData liquidity = LucideIcons.wallet;
  static const IconData dailyLimit = LucideIcons.zap;
  static const IconData runway = LucideIcons.clock;
  static const IconData budgetPressure = LucideIcons.shieldAlert;
  static const IconData incomeFlow = LucideIcons.arrowDownLeft;
  static const IconData expenseFlow = LucideIcons.arrowUpRight;

  // ---------------------------------------------------------------------------
  // 8. 10 LIFEUSE SUITE MODULES (1-TO-1 MAPPING)
  // ---------------------------------------------------------------------------
  static const IconData moneyManager = LucideIcons.wallet;
  static const IconData documentsVault = LucideIcons.shieldCheck;
  static const IconData dailyTasks = LucideIcons.checkSquare;
  static const IconData healthWellness = LucideIcons.heartPulse;
  static const IconData homeManagement = LucideIcons.home;
  static const IconData billsPayments = LucideIcons.receipt;
  static const IconData ticketsTravel = LucideIcons.plane;
  static const IconData examsLearning = LucideIcons.graduationCap;
  static const IconData personalPlanning = LucideIcons.compass;
  static const IconData remindersAlerts = LucideIcons.bellRing;

  // ---------------------------------------------------------------------------
  // 9. CONTROLS, SEARCH & AI ASSISTANCE
  // ---------------------------------------------------------------------------
  static const IconData search = LucideIcons.search;
  static const IconData filter = LucideIcons.slidersHorizontal;
  static const IconData close = LucideIcons.x;
  static const IconData sparkleAI = LucideIcons.sparkles;
  static const IconData refresh = LucideIcons.refreshCw;
}
