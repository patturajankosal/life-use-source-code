-- =============================================================================
-- Money Manager Module Schema
-- LifeUse Application
-- =============================================================================

-- 1. FINANCIAL PROFILES
CREATE TABLE IF NOT EXISTS financial_profiles (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    currency VARCHAR(10) NOT NULL DEFAULT 'INR',
    reported_balance NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    emergency_reserve NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    minimum_cash_reserve NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    week_start_day VARCHAR(15) NOT NULL DEFAULT 'MONDAY',
    timezone VARCHAR(50) NOT NULL DEFAULT 'Asia/Kolkata',
    default_carry_forward VARCHAR(20) NOT NULL DEFAULT 'UNSPENT_ONLY',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_fin_profile_user_id ON financial_profiles(user_id);

-- 2. INCOME SOURCES
CREATE TABLE IF NOT EXISTS income_sources (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    source_name VARCHAR(100) NOT NULL,
    amount NUMERIC(15,2) NOT NULL,
    frequency VARCHAR(30) NOT NULL DEFAULT 'MONTHLY',
    expected_day_of_month INT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_income_sources_user_id ON income_sources(user_id);

-- 3. EXPENSE CATEGORIES
CREATE TABLE IF NOT EXISTS expense_categories (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(50),
    color VARCHAR(20),
    is_essential BOOLEAN NOT NULL DEFAULT FALSE,
    is_system BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_expense_categories_user ON expense_categories(user_id);

-- 4. FINANCIAL COMMITMENTS
CREATE TABLE IF NOT EXISTS financial_commitments (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    commitment_type VARCHAR(30) NOT NULL,
    amount NUMERIC(15,2) NOT NULL,
    due_day_of_month INT NOT NULL,
    frequency VARCHAR(20) NOT NULL DEFAULT 'MONTHLY',
    is_essential BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_fin_commitments_user_id ON financial_commitments(user_id);
CREATE INDEX IF NOT EXISTS idx_fin_commitments_due_day ON financial_commitments(due_day_of_month);

-- 5. SAVINGS GOALS
CREATE TABLE IF NOT EXISTS savings_goals (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    target_amount NUMERIC(15,2) NOT NULL,
    current_amount NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    monthly_contribution NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    target_date DATE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_savings_goals_user_id ON savings_goals(user_id);

-- 6. BUDGET PLANS
CREATE TABLE IF NOT EXISTS budget_plans (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    period_type VARCHAR(30) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_budget NUMERIC(15,2) NOT NULL,
    carry_forward_rule VARCHAR(30) NOT NULL DEFAULT 'UNSPENT_ONLY',
    carried_forward_amount NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_budget_plans_user_dates ON budget_plans(user_id, start_date, end_date);

-- 7. BUDGET CATEGORY LIMITS
CREATE TABLE IF NOT EXISTS budget_category_limits (
    id BIGSERIAL PRIMARY KEY,
    budget_plan_id BIGINT NOT NULL REFERENCES budget_plans(id) ON DELETE CASCADE,
    category_name VARCHAR(100) NOT NULL,
    allocated_amount NUMERIC(15,2) NOT NULL,
    is_essential BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS idx_budget_cat_limits_plan ON budget_category_limits(budget_plan_id);

-- 8. PLANNED EXPENSES
CREATE TABLE IF NOT EXISTS planned_expenses (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    amount NUMERIC(15,2) NOT NULL,
    planned_date DATE NOT NULL,
    category_name VARCHAR(100),
    is_essential BOOLEAN NOT NULL DEFAULT FALSE,
    is_executed BOOLEAN NOT NULL DEFAULT FALSE,
    transaction_id BIGINT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_planned_expenses_user_date ON planned_expenses(user_id, planned_date);

-- 9. RECURRING SCHEDULES
CREATE TABLE IF NOT EXISTS recurring_schedules (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    category_name VARCHAR(100),
    amount NUMERIC(15,2) NOT NULL,
    frequency VARCHAR(30) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    day_of_month INT,
    day_of_week VARCHAR(15),
    is_essential BOOLEAN NOT NULL DEFAULT FALSE,
    payment_method VARCHAR(30),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_generated_date DATE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_rec_schedules_user_active ON recurring_schedules(user_id, is_active);

-- 10. RECURRING OCCURRENCES
CREATE TABLE IF NOT EXISTS recurring_occurrences (
    id BIGSERIAL PRIMARY KEY,
    schedule_id BIGINT NOT NULL REFERENCES recurring_schedules(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    scheduled_date DATE NOT NULL,
    amount NUMERIC(15,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    transaction_id BIGINT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_schedule_occurrence UNIQUE (schedule_id, scheduled_date)
);

CREATE INDEX IF NOT EXISTS idx_rec_occurrences_user_date ON recurring_occurrences(user_id, scheduled_date);

-- 11. FINANCIAL TRANSACTIONS
CREATE TABLE IF NOT EXISTS financial_transactions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    transaction_type VARCHAR(20) NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    sub_category VARCHAR(100),
    amount NUMERIC(15,2) NOT NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'INR',
    payment_method VARCHAR(30) NOT NULL DEFAULT 'UPI',
    transaction_date TIMESTAMP WITH TIME ZONE NOT NULL,
    is_essential BOOLEAN NOT NULL DEFAULT FALSE,
    idempotency_key VARCHAR(100),
    notes TEXT,
    planned_expense_id BIGINT REFERENCES planned_expenses(id) ON DELETE SET NULL,
    recurring_occurrence_id BIGINT REFERENCES recurring_occurrences(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_fin_tx_user_date ON financial_transactions(user_id, transaction_date DESC);
CREATE INDEX IF NOT EXISTS idx_fin_tx_user_category ON financial_transactions(user_id, category_name);
CREATE UNIQUE INDEX IF NOT EXISTS idx_fin_tx_user_idempotency ON financial_transactions(user_id, idempotency_key) WHERE idempotency_key IS NOT NULL;

-- 12. REMINDER PREFERENCES
CREATE TABLE IF NOT EXISTS reminder_preferences (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    daily_budget_reminder_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    daily_reminder_time VARCHAR(10) NOT NULL DEFAULT '09:00',
    bill_due_reminder_days_before INT NOT NULL DEFAULT 3,
    budget_threshold_warning_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    budget_threshold_percent INT NOT NULL DEFAULT 80,
    quiet_hours_start VARCHAR(10) NOT NULL DEFAULT '22:00',
    quiet_hours_end VARCHAR(10) NOT NULL DEFAULT '07:00',
    notification_channel VARCHAR(20) NOT NULL DEFAULT 'PUSH',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_reminder_pref_user ON reminder_preferences(user_id);

-- 13. USER NOTIFICATIONS
CREATE TABLE IF NOT EXISTS user_notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(30) NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_user_notif_user_read ON user_notifications(user_id, is_read, scheduled_at DESC);
