package com.lifeuse.money.repository;

import com.lifeuse.money.models.entity.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface IMoneyRepository {

    // Profile
    FinancialProfile saveProfile(FinancialProfile profile);
    Optional<FinancialProfile> findProfileByUserId(Long userId);

    // Income Sources
    IncomeSource saveIncomeSource(IncomeSource source);
    List<IncomeSource> findIncomeSourcesByUserId(Long userId);
    Optional<IncomeSource> findIncomeSourceById(Long id, Long userId);
    boolean deleteIncomeSource(Long id, Long userId);

    // Categories
    ExpenseCategory saveCategory(ExpenseCategory category);
    List<ExpenseCategory> findCategoriesByUserId(Long userId);
    Optional<ExpenseCategory> findCategoryByName(String name, Long userId);

    // Commitments
    FinancialCommitment saveCommitment(FinancialCommitment commitment);
    List<FinancialCommitment> findCommitmentsByUserId(Long userId);
    Optional<FinancialCommitment> findCommitmentById(Long id, Long userId);
    boolean deleteCommitment(Long id, Long userId);

    // Savings Goals
    SavingsGoal saveSavingsGoal(SavingsGoal goal);
    SavingsGoal updateSavingsGoal(SavingsGoal goal);
    List<SavingsGoal> findSavingsGoalsByUserId(Long userId);
    Optional<SavingsGoal> findSavingsGoalById(Long id, Long userId);
    boolean deleteSavingsGoal(Long id, Long userId);

    // Budget Plans
    BudgetPlan saveBudgetPlan(BudgetPlan plan);
    Optional<BudgetPlan> findActiveBudgetPlan(Long userId);
    List<BudgetPlan> findBudgetPlansByUserId(Long userId);
    Optional<BudgetPlan> findBudgetPlanById(Long id, Long userId);
    boolean deleteBudgetPlan(Long id, Long userId);
    void saveCategoryLimits(Long planId, List<BudgetCategoryLimit> limits);
    List<BudgetCategoryLimit> findCategoryLimitsByPlanId(Long planId);

    // Planned Expenses
    PlannedExpense savePlannedExpense(PlannedExpense expense);
    void markPlannedExpenseExecuted(Long id, Long userId, Long transactionId);
    List<PlannedExpense> findPlannedExpensesByUserId(Long userId);
    List<PlannedExpense> findUpcomingPlannedExpenses(Long userId, LocalDate fromDate, LocalDate toDate);
    Optional<PlannedExpense> findPlannedExpenseById(Long id, Long userId);
    boolean deletePlannedExpense(Long id, Long userId);

    // Recurring Schedules & Occurrences
    RecurringSchedule saveRecurringSchedule(RecurringSchedule schedule);
    List<RecurringSchedule> findRecurringSchedulesByUserId(Long userId);
    Optional<RecurringSchedule> findRecurringScheduleById(Long id, Long userId);
    boolean deleteRecurringSchedule(Long id, Long userId);
    List<RecurringSchedule> findActiveRecurringSchedules();
    void updateScheduleLastGenerated(Long scheduleId, LocalDate lastGeneratedDate);
    RecurringOccurrence saveOccurrence(RecurringOccurrence occurrence);
    Optional<RecurringOccurrence> findOccurrenceById(Long id, Long userId);
    List<RecurringOccurrence> findOccurrencesByUserAndRange(Long userId, LocalDate fromDate, LocalDate toDate);
    void markOccurrenceProcessed(Long id, Long userId, Long transactionId);

    // Transactions
    FinancialTransaction saveTransaction(FinancialTransaction transaction);
    Optional<FinancialTransaction> findTransactionById(Long id, Long userId);
    Optional<FinancialTransaction> findTransactionByIdempotencyKey(Long userId, String idempotencyKey);
    List<FinancialTransaction> findTransactions(Long userId, String type, String category, Instant fromDate, Instant toDate, int limit, int offset);
    boolean deleteTransaction(Long id, Long userId);
    BigDecimal sumExpensesToday(Long userId, Instant startOfDay, Instant endOfDay);
    BigDecimal sumByTypeAndRange(Long userId, String type, Instant fromDate, Instant toDate);
    BigDecimal sumExpensesByEssential(Long userId, boolean essential, Instant fromDate, Instant toDate);
    Map<String, BigDecimal> getExpensesByCategoryInRange(Long userId, Instant fromDate, Instant toDate);
    long countTransactions(Long userId, String type, String category, Instant fromDate, Instant toDate);

    // Reminders & Notifications
    ReminderPreference saveReminderPreference(ReminderPreference pref);
    Optional<ReminderPreference> findReminderPreferenceByUserId(Long userId);
    UserNotification saveNotification(UserNotification notification);
    List<UserNotification> findNotificationsByUserId(Long userId, int limit);
    boolean markNotificationRead(Long id, Long userId);
}
