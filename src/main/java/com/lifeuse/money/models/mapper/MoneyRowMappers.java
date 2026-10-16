package com.lifeuse.money.models.mapper;

import com.lifeuse.money.models.entity.*;
import com.lifeuse.money.models.enums.*;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;

public final class MoneyRowMappers {

    private MoneyRowMappers() {}

    private static Instant getInstant(ResultSet rs, String col) throws SQLException {
        Timestamp ts = rs.getTimestamp(col);
        return ts != null ? ts.toInstant() : null;
    }

    private static LocalDate getLocalDate(ResultSet rs, String col) throws SQLException {
        java.sql.Date d = rs.getDate(col);
        return d != null ? d.toLocalDate() : null;
    }

    public static class FinancialProfileRowMapper implements RowMapper<FinancialProfile> {
        @Override
        public FinancialProfile mapRow(ResultSet rs, int rowNum) throws SQLException {
            FinancialProfile p = new FinancialProfile();
            p.setId(rs.getLong("id"));
            p.setUserId(rs.getLong("user_id"));
            p.setCurrency(rs.getString("currency"));
            p.setReportedBalance(rs.getBigDecimal("reported_balance"));
            p.setEmergencyReserve(rs.getBigDecimal("emergency_reserve"));
            p.setMinimumCashReserve(rs.getBigDecimal("minimum_cash_reserve"));
            p.setWeekStartDay(rs.getString("week_start_day"));
            p.setTimezone(rs.getString("timezone"));
            String cf = rs.getString("default_carry_forward");
            p.setDefaultCarryForward(cf != null ? CarryForwardRule.valueOf(cf) : CarryForwardRule.UNSPENT_ONLY);
            p.setCreatedAt(getInstant(rs, "created_at"));
            p.setUpdatedAt(getInstant(rs, "updated_at"));
            return p;
        }
    }

    public static class IncomeSourceRowMapper implements RowMapper<IncomeSource> {
        @Override
        public IncomeSource mapRow(ResultSet rs, int rowNum) throws SQLException {
            IncomeSource s = new IncomeSource();
            s.setId(rs.getLong("id"));
            s.setUserId(rs.getLong("user_id"));
            s.setSourceName(rs.getString("source_name"));
            s.setAmount(rs.getBigDecimal("amount"));
            String freq = rs.getString("frequency");
            s.setFrequency(freq != null ? IncomeFrequency.valueOf(freq) : IncomeFrequency.MONTHLY);
            int day = rs.getInt("expected_day_of_month");
            s.setExpectedDayOfMonth(rs.wasNull() ? null : day);
            s.setActive(rs.getBoolean("is_active"));
            s.setNotes(rs.getString("notes"));
            s.setCreatedAt(getInstant(rs, "created_at"));
            s.setUpdatedAt(getInstant(rs, "updated_at"));
            return s;
        }
    }

    public static class ExpenseCategoryRowMapper implements RowMapper<ExpenseCategory> {
        @Override
        public ExpenseCategory mapRow(ResultSet rs, int rowNum) throws SQLException {
            ExpenseCategory c = new ExpenseCategory();
            c.setId(rs.getLong("id"));
            long userId = rs.getLong("user_id");
            c.setUserId(rs.wasNull() ? null : userId);
            c.setName(rs.getString("name"));
            c.setIcon(rs.getString("icon"));
            c.setColor(rs.getString("color"));
            c.setEssential(rs.getBoolean("is_essential"));
            c.setSystem(rs.getBoolean("is_system"));
            c.setCreatedAt(getInstant(rs, "created_at"));
            return c;
        }
    }

    public static class FinancialCommitmentRowMapper implements RowMapper<FinancialCommitment> {
        @Override
        public FinancialCommitment mapRow(ResultSet rs, int rowNum) throws SQLException {
            FinancialCommitment c = new FinancialCommitment();
            c.setId(rs.getLong("id"));
            c.setUserId(rs.getLong("user_id"));
            c.setTitle(rs.getString("title"));
            String ct = rs.getString("commitment_type");
            c.setCommitmentType(ct != null ? CommitmentType.valueOf(ct) : CommitmentType.OTHER);
            c.setAmount(rs.getBigDecimal("amount"));
            c.setDueDayOfMonth(rs.getInt("due_day_of_month"));
            c.setFrequency(rs.getString("frequency"));
            c.setEssential(rs.getBoolean("is_essential"));
            c.setActive(rs.getBoolean("is_active"));
            c.setNotes(rs.getString("notes"));
            c.setCreatedAt(getInstant(rs, "created_at"));
            c.setUpdatedAt(getInstant(rs, "updated_at"));
            return c;
        }
    }

    public static class SavingsGoalRowMapper implements RowMapper<SavingsGoal> {
        @Override
        public SavingsGoal mapRow(ResultSet rs, int rowNum) throws SQLException {
            SavingsGoal g = new SavingsGoal();
            g.setId(rs.getLong("id"));
            g.setUserId(rs.getLong("user_id"));
            g.setTitle(rs.getString("title"));
            g.setTargetAmount(rs.getBigDecimal("target_amount"));
            g.setCurrentAmount(rs.getBigDecimal("current_amount"));
            g.setMonthlyContribution(rs.getBigDecimal("monthly_contribution"));
            g.setTargetDate(getLocalDate(rs, "target_date"));
            g.setActive(rs.getBoolean("is_active"));
            g.setCreatedAt(getInstant(rs, "created_at"));
            g.setUpdatedAt(getInstant(rs, "updated_at"));
            return g;
        }
    }

    public static class BudgetPlanRowMapper implements RowMapper<BudgetPlan> {
        @Override
        public BudgetPlan mapRow(ResultSet rs, int rowNum) throws SQLException {
            BudgetPlan b = new BudgetPlan();
            b.setId(rs.getLong("id"));
            b.setUserId(rs.getLong("user_id"));
            String pt = rs.getString("period_type");
            b.setPeriodType(pt != null ? PlanPeriodType.valueOf(pt) : PlanPeriodType.MONTHLY);
            b.setStartDate(getLocalDate(rs, "start_date"));
            b.setEndDate(getLocalDate(rs, "end_date"));
            b.setTotalBudget(rs.getBigDecimal("total_budget"));
            String cfr = rs.getString("carry_forward_rule");
            b.setCarryForwardRule(cfr != null ? CarryForwardRule.valueOf(cfr) : CarryForwardRule.UNSPENT_ONLY);
            b.setCarriedForwardAmount(rs.getBigDecimal("carried_forward_amount"));
            b.setActive(rs.getBoolean("is_active"));
            b.setNotes(rs.getString("notes"));
            b.setCreatedAt(getInstant(rs, "created_at"));
            b.setUpdatedAt(getInstant(rs, "updated_at"));
            return b;
        }
    }

    public static class BudgetCategoryLimitRowMapper implements RowMapper<BudgetCategoryLimit> {
        @Override
        public BudgetCategoryLimit mapRow(ResultSet rs, int rowNum) throws SQLException {
            BudgetCategoryLimit l = new BudgetCategoryLimit();
            l.setId(rs.getLong("id"));
            l.setBudgetPlanId(rs.getLong("budget_plan_id"));
            l.setCategoryName(rs.getString("category_name"));
            l.setAllocatedAmount(rs.getBigDecimal("allocated_amount"));
            l.setEssential(rs.getBoolean("is_essential"));
            return l;
        }
    }

    public static class PlannedExpenseRowMapper implements RowMapper<PlannedExpense> {
        @Override
        public PlannedExpense mapRow(ResultSet rs, int rowNum) throws SQLException {
            PlannedExpense p = new PlannedExpense();
            p.setId(rs.getLong("id"));
            p.setUserId(rs.getLong("user_id"));
            p.setTitle(rs.getString("title"));
            p.setAmount(rs.getBigDecimal("amount"));
            p.setPlannedDate(getLocalDate(rs, "planned_date"));
            p.setCategoryName(rs.getString("category_name"));
            p.setEssential(rs.getBoolean("is_essential"));
            p.setExecuted(rs.getBoolean("is_executed"));
            long txId = rs.getLong("transaction_id");
            p.setTransactionId(rs.wasNull() ? null : txId);
            p.setNotes(rs.getString("notes"));
            p.setCreatedAt(getInstant(rs, "created_at"));
            p.setUpdatedAt(getInstant(rs, "updated_at"));
            return p;
        }
    }

    public static class RecurringScheduleRowMapper implements RowMapper<RecurringSchedule> {
        @Override
        public RecurringSchedule mapRow(ResultSet rs, int rowNum) throws SQLException {
            RecurringSchedule s = new RecurringSchedule();
            s.setId(rs.getLong("id"));
            s.setUserId(rs.getLong("user_id"));
            s.setTitle(rs.getString("title"));
            String tt = rs.getString("transaction_type");
            s.setTransactionType(tt != null ? TransactionType.valueOf(tt) : TransactionType.EXPENSE);
            s.setCategoryName(rs.getString("category_name"));
            s.setAmount(rs.getBigDecimal("amount"));
            String freq = rs.getString("frequency");
            s.setFrequency(freq != null ? RecurrenceFrequency.valueOf(freq) : RecurrenceFrequency.MONTHLY);
            s.setStartDate(getLocalDate(rs, "start_date"));
            s.setEndDate(getLocalDate(rs, "end_date"));
            int dom = rs.getInt("day_of_month");
            s.setDayOfMonth(rs.wasNull() ? null : dom);
            s.setDayOfWeek(rs.getString("day_of_week"));
            s.setEssential(rs.getBoolean("is_essential"));
            String pm = rs.getString("payment_method");
            s.setPaymentMethod(pm != null ? PaymentMethod.valueOf(pm) : PaymentMethod.UPI);
            s.setActive(rs.getBoolean("is_active"));
            s.setLastGeneratedDate(getLocalDate(rs, "last_generated_date"));
            s.setCreatedAt(getInstant(rs, "created_at"));
            s.setUpdatedAt(getInstant(rs, "updated_at"));
            return s;
        }
    }

    public static class RecurringOccurrenceRowMapper implements RowMapper<RecurringOccurrence> {
        @Override
        public RecurringOccurrence mapRow(ResultSet rs, int rowNum) throws SQLException {
            RecurringOccurrence o = new RecurringOccurrence();
            o.setId(rs.getLong("id"));
            o.setScheduleId(rs.getLong("schedule_id"));
            o.setUserId(rs.getLong("user_id"));
            o.setScheduledDate(getLocalDate(rs, "scheduled_date"));
            o.setAmount(rs.getBigDecimal("amount"));
            String st = rs.getString("status");
            o.setStatus(st != null ? OccurrenceStatus.valueOf(st) : OccurrenceStatus.PENDING);
            long txId = rs.getLong("transaction_id");
            o.setTransactionId(rs.wasNull() ? null : txId);
            o.setCreatedAt(getInstant(rs, "created_at"));
            o.setUpdatedAt(getInstant(rs, "updated_at"));
            return o;
        }
    }

    public static class FinancialTransactionRowMapper implements RowMapper<FinancialTransaction> {
        @Override
        public FinancialTransaction mapRow(ResultSet rs, int rowNum) throws SQLException {
            FinancialTransaction t = new FinancialTransaction();
            t.setId(rs.getLong("id"));
            t.setUserId(rs.getLong("user_id"));
            String tt = rs.getString("transaction_type");
            t.setTransactionType(tt != null ? TransactionType.valueOf(tt) : TransactionType.EXPENSE);
            t.setCategoryName(rs.getString("category_name"));
            t.setSubCategory(rs.getString("sub_category"));
            t.setAmount(rs.getBigDecimal("amount"));
            t.setCurrency(rs.getString("currency"));
            String pm = rs.getString("payment_method");
            t.setPaymentMethod(pm != null ? PaymentMethod.valueOf(pm) : PaymentMethod.UPI);
            t.setTransactionDate(getInstant(rs, "transaction_date"));
            t.setEssential(rs.getBoolean("is_essential"));
            t.setIdempotencyKey(rs.getString("idempotency_key"));
            t.setNotes(rs.getString("notes"));
            long plannedId = rs.getLong("planned_expense_id");
            t.setPlannedExpenseId(rs.wasNull() ? null : plannedId);
            long occId = rs.getLong("recurring_occurrence_id");
            t.setRecurringOccurrenceId(rs.wasNull() ? null : occId);
            t.setCreatedAt(getInstant(rs, "created_at"));
            t.setUpdatedAt(getInstant(rs, "updated_at"));
            return t;
        }
    }

    public static class ReminderPreferenceRowMapper implements RowMapper<ReminderPreference> {
        @Override
        public ReminderPreference mapRow(ResultSet rs, int rowNum) throws SQLException {
            ReminderPreference r = new ReminderPreference();
            r.setId(rs.getLong("id"));
            r.setUserId(rs.getLong("user_id"));
            r.setDailyBudgetReminderEnabled(rs.getBoolean("daily_budget_reminder_enabled"));
            r.setDailyReminderTime(rs.getString("daily_reminder_time"));
            r.setBillDueReminderDaysBefore(rs.getInt("bill_due_reminder_days_before"));
            r.setBudgetThresholdWarningEnabled(rs.getBoolean("budget_threshold_warning_enabled"));
            r.setBudgetThresholdPercent(rs.getInt("budget_threshold_percent"));
            r.setQuietHoursStart(rs.getString("quiet_hours_start"));
            r.setQuietHoursEnd(rs.getString("quiet_hours_end"));
            String ch = rs.getString("notification_channel");
            r.setNotificationChannel(ch != null ? NotificationChannel.valueOf(ch) : NotificationChannel.PUSH);
            r.setCreatedAt(getInstant(rs, "created_at"));
            r.setUpdatedAt(getInstant(rs, "updated_at"));
            return r;
        }
    }

    public static class UserNotificationRowMapper implements RowMapper<UserNotification> {
        @Override
        public UserNotification mapRow(ResultSet rs, int rowNum) throws SQLException {
            UserNotification n = new UserNotification();
            n.setId(rs.getLong("id"));
            n.setUserId(rs.getLong("user_id"));
            n.setTitle(rs.getString("title"));
            n.setMessage(rs.getString("message"));
            String nt = rs.getString("notification_type");
            n.setNotificationType(nt != null ? ReminderType.valueOf(nt) : ReminderType.SYSTEM);
            n.setRead(rs.getBoolean("is_read"));
            n.setScheduledAt(getInstant(rs, "scheduled_at"));
            n.setCreatedAt(getInstant(rs, "created_at"));
            return n;
        }
    }
}
