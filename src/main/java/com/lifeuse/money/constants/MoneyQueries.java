package com.lifeuse.money.constants;

public final class MoneyQueries {

    private MoneyQueries() {}

    // --- Financial Profile ---
    public static final String CREATE_PROFILE =
            "INSERT INTO financial_profiles (user_id, currency, reported_balance, emergency_reserve, minimum_cash_reserve, " +
            "week_start_day, timezone, default_carry_forward, created_at, updated_at) " +
            "VALUES (:userId, :currency, :reportedBalance, :emergencyReserve, :minimumCashReserve, :weekStartDay, :timezone, :defaultCarryForward, :createdAt, :updatedAt)";

    public static final String UPDATE_PROFILE =
            "UPDATE financial_profiles SET currency = :currency, reported_balance = :reportedBalance, " +
            "emergency_reserve = :emergencyReserve, minimum_cash_reserve = :minimumCashReserve, week_start_day = :weekStartDay, " +
            "timezone = :timezone, default_carry_forward = :defaultCarryForward, updated_at = :updatedAt WHERE user_id = :userId";

    public static final String FIND_PROFILE_BY_USER_ID =
            "SELECT * FROM financial_profiles WHERE user_id = :userId";

    // --- Income Sources ---
    public static final String CREATE_INCOME_SOURCE =
            "INSERT INTO income_sources (user_id, source_name, amount, frequency, expected_day_of_month, is_active, notes, created_at, updated_at) " +
            "VALUES (:userId, :sourceName, :amount, :frequency, :expectedDayOfMonth, :active, :notes, :createdAt, :updatedAt)";

    public static final String FIND_INCOME_SOURCES_BY_USER_ID =
            "SELECT * FROM income_sources WHERE user_id = :userId AND is_active = TRUE ORDER BY id ASC";

    public static final String FIND_INCOME_SOURCE_BY_ID =
            "SELECT * FROM income_sources WHERE id = :id AND user_id = :userId";

    public static final String DELETE_INCOME_SOURCE =
            "DELETE FROM income_sources WHERE id = :id AND user_id = :userId";

    // --- Expense Categories ---
    public static final String CREATE_CATEGORY =
            "INSERT INTO expense_categories (user_id, name, icon, color, is_essential, is_system, created_at) " +
            "VALUES (:userId, :name, :icon, :color, :essential, :system, :createdAt)";

    public static final String FIND_CATEGORIES_FOR_USER =
            "SELECT * FROM expense_categories WHERE user_id = :userId OR user_id IS NULL ORDER BY is_system DESC, name ASC";

    public static final String FIND_CATEGORY_BY_NAME =
            "SELECT * FROM expense_categories WHERE (user_id = :userId OR user_id IS NULL) AND LOWER(name) = LOWER(:name) LIMIT 1";

    // --- Financial Commitments ---
    public static final String CREATE_COMMITMENT =
            "INSERT INTO financial_commitments (user_id, title, commitment_type, amount, due_day_of_month, frequency, is_essential, is_active, notes, created_at, updated_at) " +
            "VALUES (:userId, :title, :commitmentType, :amount, :dueDayOfMonth, :frequency, :essential, :active, :notes, :createdAt, :updatedAt)";

    public static final String FIND_COMMITMENTS_BY_USER_ID =
            "SELECT * FROM financial_commitments WHERE user_id = :userId AND is_active = TRUE ORDER BY due_day_of_month ASC";

    public static final String FIND_COMMITMENT_BY_ID =
            "SELECT * FROM financial_commitments WHERE id = :id AND user_id = :userId";

    public static final String DELETE_COMMITMENT =
            "DELETE FROM financial_commitments WHERE id = :id AND user_id = :userId";

    // --- Savings Goals ---
    public static final String CREATE_SAVINGS_GOAL =
            "INSERT INTO savings_goals (user_id, title, target_amount, current_amount, monthly_contribution, target_date, is_active, created_at, updated_at) " +
            "VALUES (:userId, :title, :targetAmount, :currentAmount, :monthlyContribution, :targetDate, :active, :createdAt, :updatedAt)";

    public static final String UPDATE_SAVINGS_GOAL =
            "UPDATE savings_goals SET title = :title, target_amount = :targetAmount, current_amount = :currentAmount, " +
            "monthly_contribution = :monthlyContribution, target_date = :targetDate, is_active = :active, updated_at = :updatedAt " +
            "WHERE id = :id AND user_id = :userId";

    public static final String FIND_SAVINGS_GOALS_BY_USER_ID =
            "SELECT * FROM savings_goals WHERE user_id = :userId AND is_active = TRUE ORDER BY id ASC";

    public static final String FIND_SAVINGS_GOAL_BY_ID =
            "SELECT * FROM savings_goals WHERE id = :id AND user_id = :userId";

    public static final String DELETE_SAVINGS_GOAL =
            "DELETE FROM savings_goals WHERE id = :id AND user_id = :userId";

    // --- Budget Plans ---
    public static final String CREATE_BUDGET_PLAN =
            "INSERT INTO budget_plans (user_id, period_type, start_date, end_date, total_budget, carry_forward_rule, carried_forward_amount, is_active, notes, created_at, updated_at) " +
            "VALUES (:userId, :periodType, :startDate, :endDate, :totalBudget, :carryForwardRule, :carriedForwardAmount, :active, :notes, :createdAt, :updatedAt)";

    public static final String DEACTIVATE_OTHER_PLANS =
            "UPDATE budget_plans SET is_active = FALSE WHERE user_id = :userId";

    public static final String FIND_ACTIVE_BUDGET_PLAN =
            "SELECT * FROM budget_plans WHERE user_id = :userId AND is_active = TRUE ORDER BY id DESC LIMIT 1";

    public static final String FIND_BUDGET_PLANS_BY_USER_ID =
            "SELECT * FROM budget_plans WHERE user_id = :userId ORDER BY start_date DESC";

    public static final String FIND_BUDGET_PLAN_BY_ID =
            "SELECT * FROM budget_plans WHERE id = :id AND user_id = :userId";

    public static final String DELETE_BUDGET_PLAN =
            "DELETE FROM budget_plans WHERE id = :id AND user_id = :userId";

    // --- Budget Category Limits ---
    public static final String CREATE_CATEGORY_LIMIT =
            "INSERT INTO budget_category_limits (budget_plan_id, category_name, allocated_amount, is_essential) " +
            "VALUES (:budgetPlanId, :categoryName, :allocatedAmount, :essential)";

    public static final String FIND_CATEGORY_LIMITS_BY_PLAN =
            "SELECT * FROM budget_category_limits WHERE budget_plan_id = :budgetPlanId";

    public static final String DELETE_CATEGORY_LIMITS_BY_PLAN =
            "DELETE FROM budget_category_limits WHERE budget_plan_id = :budgetPlanId";

    // --- Planned Expenses ---
    public static final String CREATE_PLANNED_EXPENSE =
            "INSERT INTO planned_expenses (user_id, title, amount, planned_date, category_name, is_essential, is_executed, notes, created_at, updated_at) " +
            "VALUES (:userId, :title, :amount, :plannedDate, :categoryName, :essential, :executed, :notes, :createdAt, :updatedAt)";

    public static final String UPDATE_PLANNED_EXPENSE_EXECUTED =
            "UPDATE planned_expenses SET is_executed = TRUE, transaction_id = :transactionId, updated_at = :updatedAt " +
            "WHERE id = :id AND user_id = :userId";

    public static final String FIND_PLANNED_EXPENSES_BY_USER_ID =
            "SELECT * FROM planned_expenses WHERE user_id = :userId ORDER BY planned_date ASC";

    public static final String FIND_UPCOMING_PLANNED_EXPENSES =
            "SELECT * FROM planned_expenses WHERE user_id = :userId AND planned_date >= :fromDate AND planned_date <= :toDate AND is_executed = FALSE ORDER BY planned_date ASC";

    public static final String FIND_PLANNED_EXPENSE_BY_ID =
            "SELECT * FROM planned_expenses WHERE id = :id AND user_id = :userId";

    public static final String DELETE_PLANNED_EXPENSE =
            "DELETE FROM planned_expenses WHERE id = :id AND user_id = :userId";

    // --- Recurring Schedules ---
    public static final String CREATE_RECURRING_SCHEDULE =
            "INSERT INTO recurring_schedules (user_id, title, transaction_type, category_name, amount, frequency, start_date, end_date, " +
            "day_of_month, day_of_week, is_essential, payment_method, is_active, last_generated_date, created_at, updated_at) " +
            "VALUES (:userId, :title, :transactionType, :categoryName, :amount, :frequency, :startDate, :endDate, " +
            ":dayOfMonth, :dayOfWeek, :essential, :paymentMethod, :active, :lastGeneratedDate, :createdAt, :updatedAt)";

    public static final String FIND_RECURRING_SCHEDULES_BY_USER_ID =
            "SELECT * FROM recurring_schedules WHERE user_id = :userId ORDER BY id ASC";

    public static final String FIND_ACTIVE_RECURRING_SCHEDULES =
            "SELECT * FROM recurring_schedules WHERE is_active = TRUE";

    public static final String FIND_RECURRING_SCHEDULE_BY_ID =
            "SELECT * FROM recurring_schedules WHERE id = :id AND user_id = :userId";

    public static final String UPDATE_SCHEDULE_LAST_GENERATED =
            "UPDATE recurring_schedules SET last_generated_date = :lastGeneratedDate, updated_at = :updatedAt WHERE id = :id";

    public static final String DELETE_RECURRING_SCHEDULE =
            "DELETE FROM recurring_schedules WHERE id = :id AND user_id = :userId";

    // --- Recurring Occurrences ---
    public static final String CREATE_OCCURRENCE =
            "INSERT INTO recurring_occurrences (schedule_id, user_id, scheduled_date, amount, status, created_at, updated_at) " +
            "VALUES (:scheduleId, :userId, :scheduledDate, :amount, :status, :createdAt, :updatedAt) " +
            "ON CONFLICT (schedule_id, scheduled_date) DO NOTHING";

    public static final String FIND_OCCURRENCE_BY_ID =
            "SELECT * FROM recurring_occurrences WHERE id = :id AND user_id = :userId";

    public static final String FIND_OCCURRENCES_BY_USER_AND_DATE_RANGE =
            "SELECT * FROM recurring_occurrences WHERE user_id = :userId AND scheduled_date >= :fromDate AND scheduled_date <= :toDate ORDER BY scheduled_date ASC";

    public static final String UPDATE_OCCURRENCE_PROCESSED =
            "UPDATE recurring_occurrences SET status = 'PROCESSED', transaction_id = :transactionId, updated_at = :updatedAt " +
            "WHERE id = :id AND user_id = :userId";

    // --- Financial Transactions ---
    public static final String CREATE_TRANSACTION =
            "INSERT INTO financial_transactions (user_id, transaction_type, category_name, sub_category, amount, currency, " +
            "payment_method, transaction_date, is_essential, idempotency_key, notes, planned_expense_id, recurring_occurrence_id, created_at, updated_at) " +
            "VALUES (:userId, :transactionType, :categoryName, :subCategory, :amount, :currency, " +
            ":paymentMethod, :transactionDate, :essential, :idempotencyKey, :notes, :plannedExpenseId, :recurringOccurrenceId, :createdAt, :updatedAt)";

    public static final String FIND_TRANSACTION_BY_ID =
            "SELECT * FROM financial_transactions WHERE id = :id AND user_id = :userId";

    public static final String FIND_TRANSACTION_BY_IDEMPOTENCY_KEY =
            "SELECT * FROM financial_transactions WHERE user_id = :userId AND idempotency_key = :idempotencyKey";

    public static final String FIND_TRANSACTIONS_BY_USER_ID =
            "SELECT * FROM financial_transactions WHERE user_id = :userId ORDER BY transaction_date DESC";

    public static final String DELETE_TRANSACTION =
            "DELETE FROM financial_transactions WHERE id = :id AND user_id = :userId";

    public static final String SUM_EXPENSES_TODAY =
            "SELECT COALESCE(SUM(amount), 0) FROM financial_transactions " +
            "WHERE user_id = :userId AND transaction_type = 'EXPENSE' AND transaction_date >= :startOfDay AND transaction_date <= :endOfDay";

    public static final String SUM_BY_TYPE_AND_RANGE =
            "SELECT COALESCE(SUM(amount), 0) FROM financial_transactions " +
            "WHERE user_id = :userId AND transaction_type = :type AND transaction_date >= :startDate AND transaction_date <= :endDate";

    public static final String SUM_EXPENSES_BY_ESSENTIAL =
            "SELECT COALESCE(SUM(amount), 0) FROM financial_transactions " +
            "WHERE user_id = :userId AND transaction_type = 'EXPENSE' AND is_essential = :essential AND transaction_date >= :startDate AND transaction_date <= :endDate";

    // --- Reminder Preferences ---
    public static final String CREATE_REMINDER_PREFERENCE =
            "INSERT INTO reminder_preferences (user_id, daily_budget_reminder_enabled, daily_reminder_time, bill_due_reminder_days_before, " +
            "budget_threshold_warning_enabled, budget_threshold_percent, quiet_hours_start, quiet_hours_end, notification_channel, created_at, updated_at) " +
            "VALUES (:userId, :dailyBudgetReminderEnabled, :dailyReminderTime, :billDueReminderDaysBefore, " +
            ":budgetThresholdWarningEnabled, :budgetThresholdPercent, :quietHoursStart, :quietHoursEnd, :notificationChannel, :createdAt, :updatedAt)";

    public static final String UPDATE_REMINDER_PREFERENCE =
            "UPDATE reminder_preferences SET daily_budget_reminder_enabled = :dailyBudgetReminderEnabled, daily_reminder_time = :dailyReminderTime, " +
            "bill_due_reminder_days_before = :billDueReminderDaysBefore, budget_threshold_warning_enabled = :budgetThresholdWarningEnabled, " +
            "budget_threshold_percent = :budgetThresholdPercent, quiet_hours_start = :quietHoursStart, quiet_hours_end = :quietHoursEnd, " +
            "notification_channel = :notificationChannel, updated_at = :updatedAt WHERE user_id = :userId";

    public static final String FIND_REMINDER_PREFERENCE_BY_USER_ID =
            "SELECT * FROM reminder_preferences WHERE user_id = :userId";

    // --- User Notifications ---
    public static final String CREATE_NOTIFICATION =
            "INSERT INTO user_notifications (user_id, title, message, notification_type, is_read, scheduled_at, created_at) " +
            "VALUES (:userId, :title, :message, :notificationType, :read, :scheduledAt, :createdAt)";

    public static final String FIND_NOTIFICATIONS_BY_USER_ID =
            "SELECT * FROM user_notifications WHERE user_id = :userId ORDER BY scheduled_at DESC LIMIT :limit";

    public static final String MARK_NOTIFICATION_READ =
            "UPDATE user_notifications SET is_read = TRUE WHERE id = :id AND user_id = :userId";
}
