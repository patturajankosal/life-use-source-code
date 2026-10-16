/// Centralized API configuration and endpoints.
/// Matches 1-to-1 with com.lifeuse.AppRoutes on the Spring Boot backend.
class ApiConfig {
  ApiConfig._();

  // Default host for development:
  // - 127.0.0.1:8080 for physical Android device via USB (with `adb reverse tcp:8080 tcp:8080`), Web, and Desktop
  // - 10.0.2.2:8080 for Android Studio Emulator
  // - 192.168.29.181:8080 for local Wi-Fi LAN
  static const String usbPhysicalHost = 'http://127.0.0.1:8080';
  static const String androidEmulatorHost = 'http://10.0.2.2:8080';
  static const String localhost = 'http://127.0.0.1:8080';
  static const String wifiLanHost = 'http://192.168.29.181:8080';

  // Configurable base host
  static String activeHost = _getDefaultHost();

  static String _getDefaultHost() {
    return usbPhysicalHost;
  }

  // Global API base matching AppRoutes.API_BASE = "/api/lifeUse"
  static const String apiBase = '/api/lifeUse';

  static String get baseUrl => '$activeHost$apiBase';

  // Auth endpoints (matching com.lifeuse.AppRoutes.Auth)
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register';
  static String get refreshToken => '$baseUrl/auth/token/refresh';
  static String get logout => '$baseUrl/auth/token/logout';
  static String get verifyEmail => '$baseUrl/auth/verify/email';
  static String get verifyPhone => '$baseUrl/auth/verify/phone';
  static String get resendOtp => '$baseUrl/auth/verify/resend';
  static String get forgotPassword => '$baseUrl/auth/password/forgot';
  static String get resetPassword => '$baseUrl/auth/password/reset';

  // User endpoints (matching com.lifeuse.AppRoutes.User)
  static String get me => '$baseUrl/user/me';
  static String get profile => '$baseUrl/user/profile';

  // Money Manager endpoints (matching com.lifeuse.AppRoutes.Money)
  static String get moneyProfile => '$baseUrl/money/profile';
  static String get moneyIncomeSources => '$baseUrl/money/profile/income-sources';
  static String get moneyCommitments => '$baseUrl/money/profile/commitments';
  static String get moneySavingsGoals => '$baseUrl/money/profile/savings-goals';
  static String get moneyTransactions => '$baseUrl/money/transactions';
  static String get moneyTransactionSummary => '$baseUrl/money/transactions/summary';
  static String get moneyCategories => '$baseUrl/money/categories';
  static String get moneyDailyLimit => '$baseUrl/money/plan/daily-limit';
  static String get moneySpendingBreakdown => '$baseUrl/money/plan/spending-breakdown';
  static String get moneyPressure => '$baseUrl/money/plan/pressure';
  static String get moneyBudgetPlans => '$baseUrl/money/budget-plans';
  static String get moneyActiveBudgetPlan => '$baseUrl/money/budget-plans/active';
  static String get moneyPlannedExpenses => '$baseUrl/money/planned-expenses';
  static String get moneyRecurringSchedules => '$baseUrl/money/recurring-schedules';
  static String get moneyRecurringOccurrences => '$baseUrl/money/recurring-schedules/occurrences';
  static String get moneyReminderPreferences => '$baseUrl/money/reminders/preferences';
  static String get moneyNotifications => '$baseUrl/money/reminders/notifications';

  // ID-based resource routes
  static String moneyTransaction(dynamic id) => '$moneyTransactions/$id';
  static String moneyBudgetPlan(dynamic id) => '$moneyBudgetPlans/$id';
  static String moneyPlannedExpense(dynamic id) => '$moneyPlannedExpenses/$id';
  static String moneyExecutePlannedExpense(dynamic id) => '$moneyPlannedExpenses/$id/execute';
  static String moneyRecurringSchedule(dynamic id) => '$moneyRecurringSchedules/$id';
  static String moneyProcessOccurrence(dynamic id) => '$baseUrl/money/recurring-schedules/occurrences/$id/process';
  static String moneyIncomeSource(dynamic id) => '$moneyIncomeSources/$id';
  static String moneyCommitment(dynamic id) => '$moneyCommitments/$id';
  static String moneySavingsGoal(dynamic id) => '$moneySavingsGoals/$id';

  // Timeout settings
  static const Duration requestTimeout = Duration(seconds: 15);
}
