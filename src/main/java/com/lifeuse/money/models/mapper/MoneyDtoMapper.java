package com.lifeuse.money.models.mapper;

import com.lifeuse.money.models.dto.*;
import com.lifeuse.money.models.entity.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.stream.Collectors;

public final class MoneyDtoMapper {

    private MoneyDtoMapper() {}

    public static FinancialProfileResponse toProfileResponse(FinancialProfile p) {
        if (p == null) return null;
        FinancialProfileResponse r = new FinancialProfileResponse();
        r.setId(p.getId());
        r.setUserId(p.getUserId());
        r.setCurrency(p.getCurrency());
        r.setReportedBalance(p.getReportedBalance());
        r.setEmergencyReserve(p.getEmergencyReserve());
        r.setMinimumCashReserve(p.getMinimumCashReserve());
        r.setWeekStartDay(p.getWeekStartDay());
        r.setTimezone(p.getTimezone());
        r.setDefaultCarryForward(p.getDefaultCarryForward());
        r.setCreatedAt(p.getCreatedAt());
        r.setUpdatedAt(p.getUpdatedAt());
        return r;
    }

    public static IncomeSourceResponse toIncomeSourceResponse(IncomeSource s) {
        if (s == null) return null;
        IncomeSourceResponse r = new IncomeSourceResponse();
        r.setId(s.getId());
        r.setUserId(s.getUserId());
        r.setSourceName(s.getSourceName());
        r.setAmount(s.getAmount());
        r.setFrequency(s.getFrequency());
        r.setExpectedDayOfMonth(s.getExpectedDayOfMonth());
        r.setActive(s.isActive());
        r.setNotes(s.getNotes());
        r.setCreatedAt(s.getCreatedAt());
        return r;
    }

    public static FinancialCommitmentResponse toCommitmentResponse(FinancialCommitment c) {
        if (c == null) return null;
        FinancialCommitmentResponse r = new FinancialCommitmentResponse();
        r.setId(c.getId());
        r.setUserId(c.getUserId());
        r.setTitle(c.getTitle());
        r.setCommitmentType(c.getCommitmentType());
        r.setAmount(c.getAmount());
        r.setDueDayOfMonth(c.getDueDayOfMonth());
        r.setFrequency(c.getFrequency());
        r.setEssential(c.isEssential());
        r.setActive(c.isActive());
        r.setNotes(c.getNotes());
        r.setCreatedAt(c.getCreatedAt());
        return r;
    }

    public static SavingsGoalResponse toSavingsGoalResponse(SavingsGoal g) {
        if (g == null) return null;
        SavingsGoalResponse r = new SavingsGoalResponse();
        r.setId(g.getId());
        r.setUserId(g.getUserId());
        r.setTitle(g.getTitle());
        r.setTargetAmount(g.getTargetAmount());
        r.setCurrentAmount(g.getCurrentAmount());
        r.setMonthlyContribution(g.getMonthlyContribution());
        r.setTargetDate(g.getTargetDate());
        r.setActive(g.isActive());
        r.setCreatedAt(g.getCreatedAt());

        if (g.getTargetAmount() != null && g.getTargetAmount().compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal progress = g.getCurrentAmount().multiply(BigDecimal.valueOf(100))
                    .divide(g.getTargetAmount(), 2, RoundingMode.HALF_UP);
            r.setProgressPercent(progress.min(BigDecimal.valueOf(100)));
        } else {
            r.setProgressPercent(BigDecimal.ZERO);
        }
        return r;
    }

    public static CategoryResponse toCategoryResponse(ExpenseCategory c) {
        if (c == null) return null;
        CategoryResponse r = new CategoryResponse();
        r.setId(c.getId());
        r.setUserId(c.getUserId());
        r.setName(c.getName());
        r.setIcon(c.getIcon());
        r.setColor(c.getColor());
        r.setEssential(c.isEssential());
        r.setSystem(c.isSystem());
        r.setCreatedAt(c.getCreatedAt());
        return r;
    }

    public static TransactionResponse toTransactionResponse(FinancialTransaction t) {
        if (t == null) return null;
        TransactionResponse r = new TransactionResponse();
        r.setId(t.getId());
        r.setUserId(t.getUserId());
        r.setTransactionType(t.getTransactionType());
        r.setCategoryName(t.getCategoryName());
        r.setSubCategory(t.getSubCategory());
        r.setAmount(t.getAmount());
        r.setCurrency(t.getCurrency());
        r.setPaymentMethod(t.getPaymentMethod());
        r.setTransactionDate(t.getTransactionDate());
        r.setEssential(t.isEssential());
        r.setIdempotencyKey(t.getIdempotencyKey());
        r.setNotes(t.getNotes());
        r.setPlannedExpenseId(t.getPlannedExpenseId());
        r.setRecurringOccurrenceId(t.getRecurringOccurrenceId());
        r.setCreatedAt(t.getCreatedAt());
        return r;
    }

    public static BudgetPlanResponse toBudgetPlanResponse(BudgetPlan p) {
        if (p == null) return null;
        BudgetPlanResponse r = new BudgetPlanResponse();
        r.setId(p.getId());
        r.setUserId(p.getUserId());
        r.setPeriodType(p.getPeriodType());
        r.setStartDate(p.getStartDate());
        r.setEndDate(p.getEndDate());
        r.setTotalBudget(p.getTotalBudget());
        r.setCarryForwardRule(p.getCarryForwardRule());
        r.setCarriedForwardAmount(p.getCarriedForwardAmount());
        r.setActive(p.isActive());
        r.setNotes(p.getNotes());
        r.setCreatedAt(p.getCreatedAt());
        if (p.getCategoryLimits() != null) {
            r.setCategoryLimits(p.getCategoryLimits().stream()
                    .map(l -> new BudgetCategoryLimitDto(l.getCategoryName(), l.getAllocatedAmount(), l.isEssential()))
                    .collect(Collectors.toList()));
        }
        return r;
    }

    public static PlannedExpenseResponse toPlannedExpenseResponse(PlannedExpense p) {
        if (p == null) return null;
        PlannedExpenseResponse r = new PlannedExpenseResponse();
        r.setId(p.getId());
        r.setUserId(p.getUserId());
        r.setTitle(p.getTitle());
        r.setAmount(p.getAmount());
        r.setPlannedDate(p.getPlannedDate());
        r.setCategoryName(p.getCategoryName());
        r.setEssential(p.isEssential());
        r.setExecuted(p.isExecuted());
        r.setTransactionId(p.getTransactionId());
        r.setNotes(p.getNotes());
        r.setCreatedAt(p.getCreatedAt());
        return r;
    }

    public static RecurringScheduleResponse toScheduleResponse(RecurringSchedule s) {
        if (s == null) return null;
        RecurringScheduleResponse r = new RecurringScheduleResponse();
        r.setId(s.getId());
        r.setUserId(s.getUserId());
        r.setTitle(s.getTitle());
        r.setTransactionType(s.getTransactionType());
        r.setCategoryName(s.getCategoryName());
        r.setAmount(s.getAmount());
        r.setFrequency(s.getFrequency());
        r.setStartDate(s.getStartDate());
        r.setEndDate(s.getEndDate());
        r.setDayOfMonth(s.getDayOfMonth());
        r.setDayOfWeek(s.getDayOfWeek());
        r.setEssential(s.isEssential());
        r.setPaymentMethod(s.getPaymentMethod());
        r.setActive(s.isActive());
        r.setCreatedAt(s.getCreatedAt());
        return r;
    }

    public static RecurringOccurrenceResponse toOccurrenceResponse(RecurringOccurrence o, String title) {
        if (o == null) return null;
        RecurringOccurrenceResponse r = new RecurringOccurrenceResponse();
        r.setId(o.getId());
        r.setScheduleId(o.getScheduleId());
        r.setScheduleTitle(title);
        r.setUserId(o.getUserId());
        r.setScheduledDate(o.getScheduledDate());
        r.setAmount(o.getAmount());
        r.setStatus(o.getStatus());
        r.setTransactionId(o.getTransactionId());
        return r;
    }

    public static ReminderPreferenceResponse toReminderResponse(ReminderPreference p) {
        if (p == null) return null;
        ReminderPreferenceResponse r = new ReminderPreferenceResponse();
        r.setId(p.getId());
        r.setUserId(p.getUserId());
        r.setDailyBudgetReminderEnabled(p.isDailyBudgetReminderEnabled());
        r.setDailyReminderTime(p.getDailyReminderTime());
        r.setBillDueReminderDaysBefore(p.getBillDueReminderDaysBefore());
        r.setBudgetThresholdWarningEnabled(p.isBudgetThresholdWarningEnabled());
        r.setBudgetThresholdPercent(p.getBudgetThresholdPercent());
        r.setQuietHoursStart(p.getQuietHoursStart());
        r.setQuietHoursEnd(p.getQuietHoursEnd());
        r.setNotificationChannel(p.getNotificationChannel());
        r.setCreatedAt(p.getCreatedAt());
        r.setUpdatedAt(p.getUpdatedAt());
        return r;
    }

    public static UserNotificationResponse toNotificationResponse(UserNotification n) {
        if (n == null) return null;
        UserNotificationResponse r = new UserNotificationResponse();
        r.setId(n.getId());
        r.setUserId(n.getUserId());
        r.setTitle(n.getTitle());
        r.setMessage(n.getMessage());
        r.setNotificationType(n.getNotificationType());
        r.setRead(n.isRead());
        r.setScheduledAt(n.getScheduledAt());
        r.setCreatedAt(n.getCreatedAt());
        return r;
    }
}
