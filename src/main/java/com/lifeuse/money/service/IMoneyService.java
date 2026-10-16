package com.lifeuse.money.service;

import com.lifeuse.money.models.dto.*;

import java.time.Instant;
import java.util.List;

public interface IMoneyService {

    // Profile & Setup
    FinancialProfileResponse getProfile(Long userId);
    FinancialProfileResponse updateProfile(Long userId, FinancialProfileRequest request);

    // Income Sources
    List<IncomeSourceResponse> getIncomeSources(Long userId);
    IncomeSourceResponse addIncomeSource(Long userId, IncomeSourceRequest request);
    void deleteIncomeSource(Long userId, Long id);

    // Categories
    List<CategoryResponse> getCategories(Long userId);
    CategoryResponse createCategory(Long userId, CategoryRequest request);

    // Commitments
    List<FinancialCommitmentResponse> getCommitments(Long userId);
    FinancialCommitmentResponse addCommitment(Long userId, FinancialCommitmentRequest request);
    void deleteCommitment(Long userId, Long id);

    // Savings Goals
    List<SavingsGoalResponse> getSavingsGoals(Long userId);
    SavingsGoalResponse addSavingsGoal(Long userId, SavingsGoalRequest request);
    void deleteSavingsGoal(Long userId, Long id);

    // Transactions
    TransactionResponse createTransaction(Long userId, TransactionCreateRequest request);
    TransactionResponse getTransactionById(Long userId, Long id);
    List<TransactionResponse> getTransactions(Long userId, String type, String category, Instant fromDate, Instant toDate, int limit, int offset);
    void deleteTransaction(Long userId, Long id);
    TransactionSummaryResponse getTransactionSummary(Long userId, Instant fromDate, Instant toDate);

    // Spending Plan & Daily Limits
    DailySpendingLimitResponse getDailySpendingLimit(Long userId);
    SpendingBreakdownResponse getSpendingBreakdown(Long userId);
    BudgetPressureResponse getBudgetPressure(Long userId);

    // Budget Plans
    BudgetPlanResponse createBudgetPlan(Long userId, BudgetPlanRequest request);
    BudgetPlanResponse getActiveBudgetPlan(Long userId);
    List<BudgetPlanResponse> getBudgetPlans(Long userId);
    BudgetPlanResponse getBudgetPlanById(Long userId, Long id);
    void deleteBudgetPlan(Long userId, Long id);

    // Planned & Special-Day Expenses
    List<PlannedExpenseResponse> getPlannedExpenses(Long userId);
    PlannedExpenseResponse createPlannedExpense(Long userId, PlannedExpenseRequest request);
    void deletePlannedExpense(Long userId, Long id);
    TransactionResponse executePlannedExpense(Long userId, Long id);

    // Recurring Schedules
    List<RecurringScheduleResponse> getRecurringSchedules(Long userId);
    RecurringScheduleResponse createRecurringSchedule(Long userId, RecurringScheduleRequest request);
    void deleteRecurringSchedule(Long userId, Long id);
    List<RecurringOccurrenceResponse> getUpcomingOccurrences(Long userId);
    TransactionResponse processOccurrence(Long userId, Long occurrenceId);
}
