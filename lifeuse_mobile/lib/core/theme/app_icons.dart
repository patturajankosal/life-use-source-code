import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Centralized Global Iconography registry for LifeUse.
/// File: lib/core/theme/app_icons.dart
///
/// Uses the official Lucide icon library exclusively:
/// - Clean, minimal outline icons (lucide.dev)
/// - Consistent stroke weight, rounded corners, and balanced proportions
/// - Highly readable, professional aesthetic inspired by modern minimalist interfaces
/// - Seamless adaptation across Light and Dark appearance modes
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
  // 3. CORE 5-DESTINATION NAVIGATION (EXCLUSIVE MODERN LUCIDE OUTLINE)
  // ---------------------------------------------------------------------------
  static const IconData homeOutline = LucideIcons.home;
  static const IconData homeFilled = LucideIcons.home;

  static const IconData modulesOutline = LucideIcons.layoutGrid;
  static const IconData modulesFilled = LucideIcons.layoutGrid;

  static const IconData activityOutline = LucideIcons.activity;
  static const IconData activityFilled = LucideIcons.activity;

  static const IconData alertsOutline = LucideIcons.bell;
  static const IconData alertsFilled = LucideIcons.bell;
  static const IconData notifications = LucideIcons.bell;

  static const IconData profileOutline = LucideIcons.user;
  static const IconData profileFilled = LucideIcons.user;

  // ---------------------------------------------------------------------------
  // 4. 10 LIFEUSE SUITE MODULES (MODERN LUCIDE ICONS)
  // ---------------------------------------------------------------------------
  static const IconData moneyManager = LucideIcons.wallet;
  static const IconData moneyManagerFilled = LucideIcons.wallet;
  static const IconData homeManagement = LucideIcons.home;
  static const IconData homeManagementFilled = LucideIcons.home;
  static const IconData dailyTasks = LucideIcons.checkSquare;
  static const IconData dailyTasksFilled = LucideIcons.checkSquare;
  static const IconData healthWellness = LucideIcons.heartPulse;
  static const IconData healthWellnessFilled = LucideIcons.heartPulse;
  static const IconData billsPayments = LucideIcons.receipt;
  static const IconData billsPaymentsFilled = LucideIcons.receipt;
  static const IconData remindersAlerts = LucideIcons.bellRing;
  static const IconData remindersAlertsFilled = LucideIcons.bellRing;
  static const IconData ticketsTravel = LucideIcons.plane;
  static const IconData ticketsTravelFilled = LucideIcons.plane;
  static const IconData examsLearning = LucideIcons.graduationCap;
  static const IconData examsLearningFilled = LucideIcons.graduationCap;
  static const IconData documentsVault = LucideIcons.shieldCheck;
  static const IconData documentsVaultFilled = LucideIcons.shieldCheck;
  static const IconData personalPlanning = LucideIcons.compass;
  static const IconData personalPlanningFilled = LucideIcons.compass;

  // ---------------------------------------------------------------------------
  // 5. QUICK ACTIONS & FINANCIAL FLOW (MODERN LUCIDE SYSTEM)
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
  static const IconData refundFlow = LucideIcons.rotateCcw;
  static const IconData savings = LucideIcons.piggyBank;
  static const IconData creditCard = LucideIcons.creditCard;
  static const IconData analytics = LucideIcons.barChart3;
  static const IconData pieChart = LucideIcons.pieChart;
  static const IconData familyFinance = LucideIcons.users;
  static const IconData recurring = LucideIcons.repeat;
  static const IconData fileText = LucideIcons.fileText;
  static const IconData rupee = LucideIcons.indianRupee;

  // ---------------------------------------------------------------------------
  // 6. STATUS, TRENDS & FEEDBACK
  // ---------------------------------------------------------------------------
  static const IconData checkCircle = LucideIcons.checkCircle2;
  static const IconData checkCircleFilled = LucideIcons.checkCircle2;
  static const IconData check = LucideIcons.check;
  static const IconData checkCheck = LucideIcons.checkCheck;
  static const IconData errorCircle = LucideIcons.alertCircle;
  static const IconData errorCircleFilled = LucideIcons.alertCircle;
  static const IconData warningAlert = LucideIcons.alertTriangle;
  static const IconData warningAlertFilled = LucideIcons.alertTriangle;
  static const IconData pending = LucideIcons.clock;
  static const IconData badge = LucideIcons.shieldCheck;
  static const IconData trendUp = LucideIcons.trendingUp;
  static const IconData trendDown = LucideIcons.trendingDown;

  // ---------------------------------------------------------------------------
  // 7. SYSTEM ACTIONS, CONTROLS & NAVIGATION
  // ---------------------------------------------------------------------------
  static const IconData arrowBack = LucideIcons.arrowLeft;
  static const IconData arrowForward = LucideIcons.arrowRight;
  static const IconData chevronDown = LucideIcons.chevronDown;
  static const IconData chevronRight = LucideIcons.chevronRight;
  static const IconData chevronUp = LucideIcons.chevronUp;
  static const IconData chevronLeft = LucideIcons.chevronLeft;
  static const IconData logout = LucideIcons.logOut;
  static const IconData login = LucideIcons.logIn;
  static const IconData settings = LucideIcons.settings;
  static const IconData settingsFilled = LucideIcons.settings;
  static const IconData darkMode = LucideIcons.moon;
  static const IconData lightMode = LucideIcons.sun;
  static const IconData search = LucideIcons.search;
  static const IconData filter = LucideIcons.slidersHorizontal;
  static const IconData close = LucideIcons.x;
  static const IconData sparkleAI = LucideIcons.sparkles;
  static const IconData refresh = LucideIcons.refreshCw;
  static const IconData delete = LucideIcons.trash2;
  static const IconData calendar = LucideIcons.calendar;
  static const IconData plus = LucideIcons.plus;
  static const IconData plusCircle = LucideIcons.plusCircle;
  static const IconData edit = LucideIcons.pencil;

  // Aliases for modern Lucide equivalents
  static const IconData sparkles = LucideIcons.sparkles;
  static const IconData logIn = LucideIcons.logIn;
  static const IconData logOut = LucideIcons.logOut;
  static const IconData arrowLeft = LucideIcons.arrowLeft;
  static const IconData userCheck = LucideIcons.userCheck;
  static const IconData mail = LucideIcons.mail;
  static const IconData userPlus = LucideIcons.userPlus;
  static const IconData eye = LucideIcons.eye;
  static const IconData eyeOff = LucideIcons.eyeOff;
  static const IconData lock = LucideIcons.lock;
  static const IconData warning = LucideIcons.alertTriangle;
  static const IconData cloudSync = LucideIcons.cloudCog;
  static const IconData arrowDownLeft = LucideIcons.arrowDownLeft;
  static const IconData arrowUpRight = LucideIcons.arrowUpRight;
  static const IconData category = LucideIcons.layoutGrid;
  static const IconData electricity = LucideIcons.zap;
  static const IconData wifi = LucideIcons.wifi;
  static const IconData gas = LucideIcons.flame;
  static const IconData mobile = LucideIcons.smartphone;
  static const IconData car = LucideIcons.car;
  static const IconData fitness = LucideIcons.activity;
  static const IconData heart = LucideIcons.heart;
  static const IconData arrowRight = LucideIcons.arrowRight;
  static const IconData water = LucideIcons.droplets;
  static const IconData ac = LucideIcons.wind;
  static const IconData lightbulb = LucideIcons.lightbulb;
  static const IconData hotel = LucideIcons.building;
  static const IconData train = LucideIcons.train;

  // ---------------------------------------------------------------------------
  // 8. FIGMA PLATFORM & SIDEBAR (Backward-compatible)
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
}

class LifeUseIcons {
  LifeUseIcons._();

  static const String brandIconAsset = AppIcons.brandIconAsset;
  static const String brandWordmarkAsset = AppIcons.brandWordmarkAsset;

  static const IconData email = AppIcons.email;
  static const IconData phone = AppIcons.phone;
  static const IconData username = AppIcons.username;
  static const IconData userProfile = AppIcons.userProfile;
  static const IconData password = AppIcons.password;
  static const IconData passwordVisible = AppIcons.passwordVisible;
  static const IconData passwordHidden = AppIcons.passwordHidden;

  static const IconData homeOutline = AppIcons.homeOutline;
  static const IconData homeFilled = AppIcons.homeFilled;
  static const IconData modulesOutline = AppIcons.modulesOutline;
  static const IconData modulesFilled = AppIcons.modulesFilled;
  static const IconData activityOutline = AppIcons.activityOutline;
  static const IconData activityFilled = AppIcons.activityFilled;
  static const IconData alertsOutline = AppIcons.alertsOutline;
  static const IconData alertsFilled = AppIcons.alertsFilled;
  static const IconData profileOutline = AppIcons.profileOutline;
  static const IconData profileFilled = AppIcons.profileFilled;

  static const IconData moneyManager = AppIcons.moneyManager;
  static const IconData moneyManagerFilled = AppIcons.moneyManagerFilled;
  static const IconData homeManagement = AppIcons.homeManagement;
  static const IconData homeManagementFilled = AppIcons.homeManagementFilled;
  static const IconData dailyTasks = AppIcons.dailyTasks;
  static const IconData dailyTasksFilled = AppIcons.dailyTasksFilled;
  static const IconData healthWellness = AppIcons.healthWellness;
  static const IconData healthWellnessFilled = AppIcons.healthWellnessFilled;
  static const IconData billsPayments = AppIcons.billsPayments;
  static const IconData billsPaymentsFilled = AppIcons.billsPaymentsFilled;
  static const IconData remindersAlerts = AppIcons.remindersAlerts;
  static const IconData remindersAlertsFilled = AppIcons.remindersAlertsFilled;
  static const IconData ticketsTravel = AppIcons.ticketsTravel;
  static const IconData ticketsTravelFilled = AppIcons.ticketsTravelFilled;
  static const IconData examsLearning = AppIcons.examsLearning;
  static const IconData examsLearningFilled = AppIcons.examsLearningFilled;
  static const IconData documentsVault = AppIcons.documentsVault;
  static const IconData documentsVaultFilled = AppIcons.documentsVaultFilled;
  static const IconData personalPlanning = AppIcons.personalPlanning;
  static const IconData personalPlanningFilled =
      AppIcons.personalPlanningFilled;

  static const IconData addExpense = AppIcons.addExpense;
  static const IconData transfer = AppIcons.transfer;
  static const IconData scanReceipt = AppIcons.scanReceipt;
  static const IconData payDues = AppIcons.payDues;
  static const IconData liquidity = AppIcons.liquidity;
  static const IconData dailyLimit = AppIcons.dailyLimit;
  static const IconData runway = AppIcons.runway;
  static const IconData budgetPressure = AppIcons.budgetPressure;
  static const IconData incomeFlow = AppIcons.incomeFlow;
  static const IconData expenseFlow = AppIcons.expenseFlow;
  static const IconData refundFlow = AppIcons.refundFlow;
  static const IconData savings = AppIcons.savings;
  static const IconData creditCard = AppIcons.creditCard;
  static const IconData analytics = AppIcons.analytics;
  static const IconData pieChart = AppIcons.pieChart;
  static const IconData familyFinance = AppIcons.familyFinance;
  static const IconData recurring = AppIcons.recurring;
  static const IconData fileText = AppIcons.fileText;
  static const IconData rupee = AppIcons.rupee;

  static const IconData checkCircle = AppIcons.checkCircle;
  static const IconData checkCircleFilled = AppIcons.checkCircleFilled;
  static const IconData check = AppIcons.check;
  static const IconData checkCheck = AppIcons.checkCheck;
  static const IconData errorCircle = AppIcons.errorCircle;
  static const IconData errorCircleFilled = AppIcons.errorCircleFilled;
  static const IconData warningAlert = AppIcons.warningAlert;
  static const IconData warningAlertFilled = AppIcons.warningAlertFilled;
  static const IconData pending = AppIcons.pending;
  static const IconData badge = AppIcons.badge;
  static const IconData trendUp = AppIcons.trendUp;
  static const IconData trendDown = AppIcons.trendDown;

  static const IconData arrowBack = AppIcons.arrowBack;
  static const IconData arrowForward = AppIcons.arrowForward;
  static const IconData chevronDown = AppIcons.chevronDown;
  static const IconData chevronRight = AppIcons.chevronRight;
  static const IconData chevronUp = AppIcons.chevronUp;
  static const IconData chevronLeft = AppIcons.chevronLeft;
  static const IconData logout = AppIcons.logout;
  static const IconData login = AppIcons.login;
  static const IconData settings = AppIcons.settings;
  static const IconData settingsFilled = AppIcons.settingsFilled;
  static const IconData darkMode = AppIcons.darkMode;
  static const IconData lightMode = AppIcons.lightMode;
  static const IconData search = AppIcons.search;
  static const IconData filter = AppIcons.filter;
  static const IconData close = AppIcons.close;
  static const IconData sparkleAI = AppIcons.sparkleAI;
  static const IconData refresh = AppIcons.refresh;
  static const IconData delete = AppIcons.delete;
  static const IconData calendar = AppIcons.calendar;
  static const IconData plus = AppIcons.plus;
  static const IconData plusCircle = AppIcons.plusCircle;
  static const IconData edit = AppIcons.edit;

  static const IconData sparkles = AppIcons.sparkles;
  static const IconData logIn = AppIcons.logIn;
  static const IconData logOut = AppIcons.logOut;
  static const IconData arrowLeft = AppIcons.arrowLeft;
  static const IconData userCheck = AppIcons.userCheck;
  static const IconData mail = AppIcons.mail;
  static const IconData userPlus = AppIcons.userPlus;
  static const IconData eye = AppIcons.eye;
  static const IconData eyeOff = AppIcons.eyeOff;
  static const IconData lock = AppIcons.lock;
  static const IconData warning = AppIcons.warning;
  static const IconData cloudSync = AppIcons.cloudSync;
  static const IconData arrowDownLeft = AppIcons.arrowDownLeft;
  static const IconData arrowUpRight = AppIcons.arrowUpRight;
  static const IconData category = AppIcons.category;
  static const IconData electricity = AppIcons.electricity;
  static const IconData wifi = AppIcons.wifi;
  static const IconData gas = AppIcons.gas;
  static const IconData mobile = AppIcons.mobile;
  static const IconData car = AppIcons.car;
  static const IconData fitness = AppIcons.fitness;
  static const IconData heart = AppIcons.heart;
  static const IconData arrowRight = AppIcons.arrowRight;
  static const IconData water = AppIcons.water;
  static const IconData ac = AppIcons.ac;
  static const IconData lightbulb = AppIcons.lightbulb;
  static const IconData hotel = AppIcons.hotel;
  static const IconData train = AppIcons.train;

  static const IconData dashboard = AppIcons.dashboard;
  static const IconData staff = AppIcons.staff;
  static const IconData targetTracking = AppIcons.targetTracking;
  static const IconData orgChart = AppIcons.orgChart;
  static const IconData attendance = AppIcons.attendance;
  static const IconData attendanceApproval = AppIcons.attendanceApproval;
  static const IconData travelAllowance = AppIcons.travelAllowance;
  static const IconData leaves = AppIcons.leaves;
  static const IconData permission = AppIcons.permission;
  static const IconData workFromHome = AppIcons.workFromHome;
  static const IconData hiring = AppIcons.hiring;
  static const IconData salarySlip = AppIcons.salarySlip;
  static const IconData fineAndDeduction = AppIcons.fineAndDeduction;
  static const IconData incentives = AppIcons.incentives;
  static const IconData backToWorkspace = AppIcons.backToWorkspace;
}
