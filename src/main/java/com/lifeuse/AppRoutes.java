package com.lifeuse;

import java.util.List;

/**
 * =====================================================================================================================
 * LIFEUSE — ENTERPRISE CENTRALIZED ROUTE REGISTRY
 * =====================================================================================================================
 *
 * ARCHITECTURE STANDARD:
 * Every single API endpoint in the application MUST be registered here with:
 *   1. HTTP Method   : Clearly specified in constant name (POST_, GET_, PUT_, PATCH_, DELETE_)
 *   2. Endpoint Path : Mobile REST standard format (/api/v1/<module>/<action>)
 *   3. Controller Map: Target controller file and method documented on each route
 *   4. Access Policy : PUBLIC or AUTHENTICATED (used in SecurityConfiguration)
 *
 * =====================================================================================================================
 * MASTER API ROUTING TABLE
 * =====================================================================================================================
 * HTTP METHOD | ENDPOINT ROUTE                         | TARGET CONTROLLER & FUNCTION             | ACCESS LEVEL
 * ------------+----------------------------------------+------------------------------------------+--------------
 * POST        | /api/lifeUse/auth/login                | LoginController.login()                  | PUBLIC
 * POST        | /api/lifeUse/auth/register             | RegisterController.register()            | PUBLIC
 * POST        | /api/lifeUse/auth/verify/email         | VerificationController.verifyEmail()     | PUBLIC
 * POST        | /api/lifeUse/auth/verify/phone         | VerificationController.verifyPhone()     | PUBLIC
 * POST        | /api/lifeUse/auth/verify/resend        | VerificationController.resendOtp()       | PUBLIC
 * POST        | /api/lifeUse/auth/password/forgot      | PasswordResetController.forgotPassword() | PUBLIC
 * POST        | /api/lifeUse/auth/password/reset       | PasswordResetController.resetPassword()  | PUBLIC
 * POST        | /api/lifeUse/auth/password/change      | PasswordResetController.changePassword() | AUTHENTICATED
 * POST        | /api/lifeUse/auth/token/refresh        | TokenController.refreshToken()           | PUBLIC
 * POST        | /api/lifeUse/auth/token/logout         | TokenController.logout()                 | AUTHENTICATED
 * GET         | /api/lifeUse/user/me                   | UserController.getCurrentUser()          | AUTHENTICATED
 * =====================================================================================================================
 *
 * HOW TO ADD A NEW ROUTE / MODULE:
 * --------------------------------
 * 1. Create a nested static class for your module (e.g., Notification, Payment, Feed).
 * 2. Prefix your constant with the HTTP method:
 *      public static final String POST_CREATE = BASE + "/create";
 *      public static final String GET_LIST    = BASE + "/list";
 *      public static final String PUT_UPDATE  = BASE + "/update";
 *      public static final String DELETE_ITEM = BASE + "/delete";
 * 3. If public, add to PUBLIC_ROUTES array.
 * =====================================================================================================================
 */
public final class AppRoutes {

    private AppRoutes() {
        // Static route registry — prevent instantiation
    }

    // =================================================================================================================
    // GLOBAL API BASE
    // =================================================================================================================
    public static final String API_BASE = "/api/lifeUse";

    // =================================================================================================================
    // MODULE: AUTHENTICATION  (/api/v1/auth/*)
    // =================================================================================================================
    public static final class Auth {
        private Auth() {}

        public static final String BASE = API_BASE + "/auth";

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: POST | Route: /api/v1/auth/login
        // Target: LoginController.login(LoginRequest)
        // Access: PUBLIC
        // -------------------------------------------------------------------------------------------------------------
        public static final String POST_LOGIN                 = BASE + "/login";
        public static final String LOGIN                      = POST_LOGIN; // alias

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: POST | Route: /api/v1/auth/register
        // Target: RegisterController.register(RegisterRequest)
        // Access: PUBLIC
        // -------------------------------------------------------------------------------------------------------------
        public static final String POST_REGISTER              = BASE + "/register";
        public static final String REGISTER                   = POST_REGISTER; // alias

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: POST | Route: /api/v1/auth/verify/email
        // Target: VerificationController.verifyEmail(EmailVerificationRequest)
        // Access: PUBLIC
        // -------------------------------------------------------------------------------------------------------------
        public static final String POST_VERIFY_EMAIL          = BASE + "/verify/email";
        public static final String VERIFY_EMAIL               = POST_VERIFY_EMAIL; // alias

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: POST | Route: /api/v1/auth/verify/phone
        // Target: VerificationController.verifyPhone(PhoneVerificationRequest)
        // Access: PUBLIC
        // -------------------------------------------------------------------------------------------------------------
        public static final String POST_VERIFY_PHONE          = BASE + "/verify/phone";
        public static final String VERIFY_PHONE               = POST_VERIFY_PHONE; // alias

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: POST | Route: /api/v1/auth/verify/resend
        // Target: VerificationController.resendOtp(ResendOtpRequest)
        // Access: PUBLIC
        // -------------------------------------------------------------------------------------------------------------
        public static final String POST_RESEND_OTP            = BASE + "/verify/resend";
        public static final String RESEND_OTP                 = POST_RESEND_OTP; // alias

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: POST | Route: /api/v1/auth/password/forgot
        // Target: PasswordResetController.forgotPassword(ForgotPasswordRequest)
        // Access: PUBLIC
        // -------------------------------------------------------------------------------------------------------------
        public static final String POST_FORGOT_PASSWORD       = BASE + "/password/forgot";
        public static final String FORGOT_PASSWORD            = POST_FORGOT_PASSWORD; // alias

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: POST | Route: /api/v1/auth/password/reset
        // Target: PasswordResetController.resetPassword(ResetPasswordRequest)
        // Access: PUBLIC
        // -------------------------------------------------------------------------------------------------------------
        public static final String POST_RESET_PASSWORD        = BASE + "/password/reset";
        public static final String RESET_PASSWORD             = POST_RESET_PASSWORD; // alias

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: POST | Route: /api/v1/auth/password/change
        // Target: PasswordResetController.changePassword(User, ChangePasswordRequest)
        // Access: AUTHENTICATED
        // -------------------------------------------------------------------------------------------------------------
        public static final String POST_CHANGE_PASSWORD       = BASE + "/password/change";
        public static final String CHANGE_PASSWORD            = POST_CHANGE_PASSWORD; // alias

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: POST | Route: /api/v1/auth/token/refresh
        // Target: TokenController.refreshToken(RefreshTokenRequest)
        // Access: PUBLIC
        // -------------------------------------------------------------------------------------------------------------
        public static final String POST_REFRESH_TOKEN         = BASE + "/token/refresh";
        public static final String REFRESH_TOKEN              = POST_REFRESH_TOKEN; // alias

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: POST | Route: /api/v1/auth/token/logout
        // Target: TokenController.logout(RefreshTokenRequest)
        // Access: AUTHENTICATED
        // -------------------------------------------------------------------------------------------------------------
        public static final String POST_LOGOUT                = BASE + "/token/logout";
        public static final String LOGOUT                     = POST_LOGOUT; // alias
    }

    // =================================================================================================================
    // MODULE: USER  (/api/v1/user/*)
    // =================================================================================================================
    public static final class User {
        private User() {}

        public static final String BASE = API_BASE + "/user";

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: GET | Route: /api/v1/user/me
        // Target: UserController.getCurrentUser(UserDetails)
        // Access: AUTHENTICATED
        // -------------------------------------------------------------------------------------------------------------
        public static final String GET_ME                     = BASE + "/me";
        public static final String ME                         = GET_ME; // alias

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: PUT | Route: /api/v1/user/profile
        // Target: UserController.updateProfile()
        // Access: AUTHENTICATED
        // -------------------------------------------------------------------------------------------------------------
        public static final String PUT_UPDATE_PROFILE         = BASE + "/profile";
        public static final String UPDATE_PROFILE             = PUT_UPDATE_PROFILE; // alias

        // -------------------------------------------------------------------------------------------------------------
        // HTTP: DELETE | Route: /api/v1/user/delete
        // Target: UserController.deleteAccount()
        // Access: AUTHENTICATED
        // -------------------------------------------------------------------------------------------------------------
        public static final String DELETE_ACCOUNT             = BASE + "/delete";
    }

    // =================================================================================================================
    // MODULE: NOTIFICATION  (/api/v1/notification/*) — Template for future implementation
    // =================================================================================================================
    public static final class Notification {
        private Notification() {}

        public static final String BASE = API_BASE + "/notification";

        // HTTP: GET | Route: /api/v1/notification/list
        public static final String GET_LIST                   = BASE + "/list";
        public static final String LIST                       = GET_LIST;

        // HTTP: PUT | Route: /api/v1/notification/read
        public static final String PUT_MARK_READ              = BASE + "/read";
        public static final String MARK_READ                  = PUT_MARK_READ;

        // HTTP: PUT | Route: /api/v1/notification/read-all
        public static final String PUT_MARK_ALL_READ          = BASE + "/read-all";
        public static final String MARK_ALL_READ              = PUT_MARK_ALL_READ;

        // HTTP: DELETE | Route: /api/v1/notification/delete
        public static final String DELETE_NOTIFICATION        = BASE + "/delete";
        public static final String DELETE                     = DELETE_NOTIFICATION;
    }

    // =================================================================================================================
    // MODULE: FEED  (/api/v1/feed/*) — Template for future implementation
    // =================================================================================================================
    public static final class Feed {
        private Feed() {}

        public static final String BASE = API_BASE + "/feed";

        // HTTP: GET | Route: /api/v1/feed/list
        public static final String GET_FEED_LIST              = BASE + "/list";
        public static final String LIST                       = GET_FEED_LIST;

        // HTTP: POST | Route: /api/v1/feed/post
        public static final String POST_CREATE_POST           = BASE + "/post";
        public static final String CREATE_POST                = POST_CREATE_POST;

        // HTTP: DELETE | Route: /api/v1/feed/post/delete
        public static final String DELETE_POST                = BASE + "/post/delete";
    }

    // =================================================================================================================
    // MODULE: PROFILE  (/api/v1/profile/*) — Template for future implementation
    // =================================================================================================================
    public static final class Profile {
        private Profile() {}

        public static final String BASE = API_BASE + "/profile";

        // HTTP: GET | Route: /api/v1/profile/get
        public static final String GET_PROFILE                = BASE + "/get";
        public static final String GET                        = GET_PROFILE;

        // HTTP: PUT | Route: /api/v1/profile/avatar
        public static final String PUT_UPDATE_AVATAR          = BASE + "/avatar";
        public static final String UPDATE_AVATAR              = PUT_UPDATE_AVATAR;

        // HTTP: PUT | Route: /api/v1/profile/preferences
        public static final String PUT_UPDATE_PREFERENCES     = BASE + "/preferences";
        public static final String PREFERENCES                = PUT_UPDATE_PREFERENCES;
    }

    // =================================================================================================================
    // MODULE: MONEY MANAGER (/api/lifeUse/money/*)
    // =================================================================================================================
    public static final class Money {
        private Money() {}

        public static final String BASE = API_BASE + "/money";

        // Financial Profile & Setup
        public static final String GET_PROFILE                  = BASE + "/profile";
        public static final String PUT_PROFILE                  = BASE + "/profile";
        public static final String GET_INCOME_SOURCES           = BASE + "/profile/income-sources";
        public static final String POST_INCOME_SOURCE           = BASE + "/profile/income-sources";
        public static final String DELETE_INCOME_SOURCE         = BASE + "/profile/income-sources/{id}";
        public static final String GET_COMMITMENTS              = BASE + "/profile/commitments";
        public static final String POST_COMMITMENT              = BASE + "/profile/commitments";
        public static final String DELETE_COMMITMENT            = BASE + "/profile/commitments/{id}";
        public static final String GET_SAVINGS_GOALS            = BASE + "/profile/savings-goals";
        public static final String POST_SAVINGS_GOAL            = BASE + "/profile/savings-goals";
        public static final String DELETE_SAVINGS_GOAL          = BASE + "/profile/savings-goals/{id}";

        // Transactions
        public static final String GET_TRANSACTIONS             = BASE + "/transactions";
        public static final String POST_TRANSACTION             = BASE + "/transactions";
        public static final String GET_TRANSACTION_BY_ID        = BASE + "/transactions/{id}";
        public static final String DELETE_TRANSACTION           = BASE + "/transactions/{id}";
        public static final String GET_TRANSACTION_SUMMARY      = BASE + "/transactions/summary";
        public static final String GET_CATEGORIES               = BASE + "/categories";
        public static final String POST_CATEGORY                = BASE + "/categories";

        // Intelligent Spending Plan & Daily Limits
        public static final String GET_DAILY_LIMIT              = BASE + "/plan/daily-limit";
        public static final String GET_SPENDING_BREAKDOWN       = BASE + "/plan/spending-breakdown";
        public static final String GET_BUDGET_PRESSURE          = BASE + "/plan/pressure";

        // Budget Plans
        public static final String GET_BUDGET_PLANS             = BASE + "/budget-plans";
        public static final String POST_BUDGET_PLAN             = BASE + "/budget-plans";
        public static final String GET_ACTIVE_BUDGET_PLAN       = BASE + "/budget-plans/active";
        public static final String GET_BUDGET_PLAN_BY_ID        = BASE + "/budget-plans/{id}";
        public static final String DELETE_BUDGET_PLAN           = BASE + "/budget-plans/{id}";

        // Planned & Special-Day Expenses
        public static final String GET_PLANNED_EXPENSES         = BASE + "/planned-expenses";
        public static final String POST_PLANNED_EXPENSE         = BASE + "/planned-expenses";
        public static final String DELETE_PLANNED_EXPENSE       = BASE + "/planned-expenses/{id}";
        public static final String POST_EXECUTE_PLANNED_EXP     = BASE + "/planned-expenses/{id}/execute";

        // Recurring Schedules
        public static final String GET_RECURRING_SCHEDULES      = BASE + "/recurring-schedules";
        public static final String POST_RECURRING_SCHEDULE      = BASE + "/recurring-schedules";
        public static final String DELETE_RECURRING_SCHEDULE    = BASE + "/recurring-schedules/{id}";
        public static final String GET_UPCOMING_OCCURRENCES     = BASE + "/recurring-schedules/occurrences";
        public static final String POST_PROCESS_OCCURRENCE      = BASE + "/recurring-schedules/occurrences/{id}/process";

        // Reminders & Notifications
        public static final String GET_REMINDER_PREFS           = BASE + "/reminders/preferences";
        public static final String PUT_REMINDER_PREFS           = BASE + "/reminders/preferences";
        public static final String GET_NOTIFICATIONS            = BASE + "/reminders/notifications";
        public static final String PUT_MARK_NOTIFICATION_READ   = BASE + "/reminders/notifications/{id}/read";
    }

    // =================================================================================================================
    // PUBLIC ROUTES — Permitted without authentication by Spring Security
    // =================================================================================================================
    public static final String[] PUBLIC_ROUTES = {
            Auth.POST_LOGIN,
            Auth.POST_REGISTER,
            Auth.POST_VERIFY_EMAIL,
            Auth.POST_VERIFY_PHONE,
            Auth.POST_RESEND_OTP,
            Auth.POST_FORGOT_PASSWORD,
            Auth.POST_RESET_PASSWORD,
            Auth.POST_REFRESH_TOKEN,
            "/v3/api-docs/**",
            "/swagger-ui/**",
            "/swagger-ui.html"
    };

    // =================================================================================================================
    // ROUTE METADATA RECORD (For programmatic inspection, documentation & security auditing)
    // =================================================================================================================
    public record RouteMetadata(
            String httpMethod,
            String path,
            String targetController,
            String targetMethod,
            boolean isPublic
    ) {}

    public static List<RouteMetadata> getAllDefinedRoutes() {
        return List.of(
                new RouteMetadata("POST", Auth.POST_LOGIN,           "LoginController",         "login",               true),
                new RouteMetadata("POST", Auth.POST_REGISTER,        "RegisterController",      "register",            true),
                new RouteMetadata("POST", Auth.POST_VERIFY_EMAIL,    "VerificationController",  "verifyEmail",         true),
                new RouteMetadata("POST", Auth.POST_VERIFY_PHONE,    "VerificationController",  "verifyPhone",         true),
                new RouteMetadata("POST", Auth.POST_RESEND_OTP,      "VerificationController",  "resendOtp",           true),
                new RouteMetadata("POST", Auth.POST_FORGOT_PASSWORD, "PasswordResetController", "forgotPassword",     true),
                new RouteMetadata("POST", Auth.POST_RESET_PASSWORD,  "PasswordResetController", "resetPassword",      true),
                new RouteMetadata("POST", Auth.POST_CHANGE_PASSWORD, "PasswordResetController", "changePassword",     false),
                new RouteMetadata("POST", Auth.POST_REFRESH_TOKEN,   "TokenController",         "refreshToken",        true),
                new RouteMetadata("POST", Auth.POST_LOGOUT,          "TokenController",         "logout",              false),
                new RouteMetadata("GET",  User.GET_ME,               "UserController",          "getCurrentUser",      false),

                // Money Manager Routes
                new RouteMetadata("GET",  Money.GET_PROFILE,                  "MoneyProfileController",      "getProfile",               false),
                new RouteMetadata("PUT",  Money.PUT_PROFILE,                  "MoneyProfileController",      "updateProfile",            false),
                new RouteMetadata("GET",  Money.GET_INCOME_SOURCES,           "MoneyProfileController",      "getIncomeSources",         false),
                new RouteMetadata("POST", Money.POST_INCOME_SOURCE,           "MoneyProfileController",      "addIncomeSource",          false),
                new RouteMetadata("DELETE", Money.DELETE_INCOME_SOURCE,       "MoneyProfileController",      "deleteIncomeSource",       false),
                new RouteMetadata("GET",  Money.GET_COMMITMENTS,              "MoneyProfileController",      "getCommitments",           false),
                new RouteMetadata("POST", Money.POST_COMMITMENT,              "MoneyProfileController",      "addCommitment",            false),
                new RouteMetadata("DELETE", Money.DELETE_COMMITMENT,          "MoneyProfileController",      "deleteCommitment",         false),
                new RouteMetadata("GET",  Money.GET_SAVINGS_GOALS,            "MoneyProfileController",      "getSavingsGoals",          false),
                new RouteMetadata("POST", Money.POST_SAVINGS_GOAL,            "MoneyProfileController",      "addSavingsGoal",           false),
                new RouteMetadata("DELETE", Money.DELETE_SAVINGS_GOAL,        "MoneyProfileController",      "deleteSavingsGoal",        false),

                new RouteMetadata("GET",  Money.GET_TRANSACTIONS,             "TransactionController",       "getTransactions",          false),
                new RouteMetadata("POST", Money.POST_TRANSACTION,             "TransactionController",       "createTransaction",        false),
                new RouteMetadata("GET",  Money.GET_TRANSACTION_BY_ID,        "TransactionController",       "getTransactionById",       false),
                new RouteMetadata("DELETE", Money.DELETE_TRANSACTION,         "TransactionController",       "deleteTransaction",        false),
                new RouteMetadata("GET",  Money.GET_TRANSACTION_SUMMARY,      "TransactionController",       "getTransactionSummary",     false),
                new RouteMetadata("GET",  Money.GET_CATEGORIES,               "TransactionController",       "getCategories",            false),
                new RouteMetadata("POST", Money.POST_CATEGORY,                "TransactionController",       "createCategory",           false),

                new RouteMetadata("GET",  Money.GET_DAILY_LIMIT,              "SpendingPlanController",      "getDailySpendingLimit",    false),
                new RouteMetadata("GET",  Money.GET_SPENDING_BREAKDOWN,       "SpendingPlanController",      "getSpendingBreakdown",     false),
                new RouteMetadata("GET",  Money.GET_BUDGET_PRESSURE,          "SpendingPlanController",      "getBudgetPressure",        false),

                new RouteMetadata("GET",  Money.GET_BUDGET_PLANS,             "BudgetPlanController",        "getBudgetPlans",           false),
                new RouteMetadata("POST", Money.POST_BUDGET_PLAN,             "BudgetPlanController",        "createBudgetPlan",         false),
                new RouteMetadata("GET",  Money.GET_ACTIVE_BUDGET_PLAN,       "BudgetPlanController",        "getActiveBudgetPlan",      false),
                new RouteMetadata("GET",  Money.GET_BUDGET_PLAN_BY_ID,        "BudgetPlanController",        "getBudgetPlanById",        false),
                new RouteMetadata("DELETE", Money.DELETE_BUDGET_PLAN,         "BudgetPlanController",        "deleteBudgetPlan",         false),

                new RouteMetadata("GET",  Money.GET_PLANNED_EXPENSES,         "PlannedExpenseController",    "getPlannedExpenses",       false),
                new RouteMetadata("POST", Money.POST_PLANNED_EXPENSE,         "PlannedExpenseController",    "createPlannedExpense",     false),
                new RouteMetadata("DELETE", Money.DELETE_PLANNED_EXPENSE,     "PlannedExpenseController",    "deletePlannedExpense",     false),
                new RouteMetadata("POST", Money.POST_EXECUTE_PLANNED_EXP,     "PlannedExpenseController",    "executePlannedExpense",    false),

                new RouteMetadata("GET",  Money.GET_RECURRING_SCHEDULES,      "RecurringScheduleController", "getRecurringSchedules",    false),
                new RouteMetadata("POST", Money.POST_RECURRING_SCHEDULE,      "RecurringScheduleController", "createRecurringSchedule",  false),
                new RouteMetadata("DELETE", Money.DELETE_RECURRING_SCHEDULE,  "RecurringScheduleController", "deleteRecurringSchedule",  false),
                new RouteMetadata("GET",  Money.GET_UPCOMING_OCCURRENCES,     "RecurringScheduleController", "getUpcomingOccurrences",   false),
                new RouteMetadata("POST", Money.POST_PROCESS_OCCURRENCE,      "RecurringScheduleController", "processOccurrence",         false),

                new RouteMetadata("GET",  Money.GET_REMINDER_PREFS,           "ReminderController",          "getReminderPreferences",   false),
                new RouteMetadata("PUT",  Money.PUT_REMINDER_PREFS,           "ReminderController",          "updateReminderPreferences",false),
                new RouteMetadata("GET",  Money.GET_NOTIFICATIONS,            "ReminderController",          "getUserNotifications",     false),
                new RouteMetadata("PUT",  Money.PUT_MARK_NOTIFICATION_READ,   "ReminderController",          "markNotificationAsRead",   false)
        );
    }
}
