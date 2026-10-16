package com.lifeuse.money.repository;

import com.lifeuse.common.exception.DatabaseOperationException;
import com.lifeuse.money.constants.MoneyQueries;
import com.lifeuse.money.models.entity.*;
import com.lifeuse.money.models.mapper.MoneyRowMappers;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.util.*;

@Repository
public class MoneyRepository implements IMoneyRepository {

    private final NamedParameterJdbcTemplate jdbcTemplate;

    private final MoneyRowMappers.FinancialProfileRowMapper profileRowMapper = new MoneyRowMappers.FinancialProfileRowMapper();
    private final MoneyRowMappers.IncomeSourceRowMapper incomeSourceRowMapper = new MoneyRowMappers.IncomeSourceRowMapper();
    private final MoneyRowMappers.ExpenseCategoryRowMapper categoryRowMapper = new MoneyRowMappers.ExpenseCategoryRowMapper();
    private final MoneyRowMappers.FinancialCommitmentRowMapper commitmentRowMapper = new MoneyRowMappers.FinancialCommitmentRowMapper();
    private final MoneyRowMappers.SavingsGoalRowMapper savingsGoalRowMapper = new MoneyRowMappers.SavingsGoalRowMapper();
    private final MoneyRowMappers.BudgetPlanRowMapper budgetPlanRowMapper = new MoneyRowMappers.BudgetPlanRowMapper();
    private final MoneyRowMappers.BudgetCategoryLimitRowMapper categoryLimitRowMapper = new MoneyRowMappers.BudgetCategoryLimitRowMapper();
    private final MoneyRowMappers.PlannedExpenseRowMapper plannedExpenseRowMapper = new MoneyRowMappers.PlannedExpenseRowMapper();
    private final MoneyRowMappers.RecurringScheduleRowMapper recurringScheduleRowMapper = new MoneyRowMappers.RecurringScheduleRowMapper();
    private final MoneyRowMappers.RecurringOccurrenceRowMapper occurrenceRowMapper = new MoneyRowMappers.RecurringOccurrenceRowMapper();
    private final MoneyRowMappers.FinancialTransactionRowMapper transactionRowMapper = new MoneyRowMappers.FinancialTransactionRowMapper();
    private final MoneyRowMappers.ReminderPreferenceRowMapper reminderPreferenceRowMapper = new MoneyRowMappers.ReminderPreferenceRowMapper();
    private final MoneyRowMappers.UserNotificationRowMapper notificationRowMapper = new MoneyRowMappers.UserNotificationRowMapper();

    public MoneyRepository(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // =========================================================================
    // Database Execution Helper Wrappers
    // =========================================================================

    @FunctionalInterface
    private interface DbSupplier<T> {
        T get() throws DataAccessException;
    }

    @FunctionalInterface
    private interface DbAction {
        void run() throws DataAccessException;
    }

    private <T> T execute(String operation, DbSupplier<T> supplier) {
        try {
            return supplier.get();
        } catch (DataIntegrityViolationException ex) {
            throw ex;
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to " + operation, ex);
        }
    }

    private void executeAction(String operation, DbAction action) {
        try {
            action.run();
        } catch (DataIntegrityViolationException ex) {
            throw ex;
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to " + operation, ex);
        }
    }

    // =========================================================================
    // Financial Profile
    // =========================================================================

    @Override
    public FinancialProfile saveProfile(FinancialProfile profile) {
        return execute("save financial profile", () -> {
            Instant now = Instant.now();
            Optional<FinancialProfile> existing = findProfileByUserId(profile.getUserId());
            if (existing.isPresent()) {
                MapSqlParameterSource params = new MapSqlParameterSource()
                        .addValue("userId", profile.getUserId())
                        .addValue("currency", profile.getCurrency())
                        .addValue("reportedBalance", profile.getReportedBalance())
                        .addValue("emergencyReserve", profile.getEmergencyReserve())
                        .addValue("minimumCashReserve", profile.getMinimumCashReserve())
                        .addValue("weekStartDay", profile.getWeekStartDay())
                        .addValue("timezone", profile.getTimezone())
                        .addValue("defaultCarryForward", profile.getDefaultCarryForward() != null ? profile.getDefaultCarryForward().name() : "UNSPENT_ONLY")
                        .addValue("updatedAt", Timestamp.from(now));
                jdbcTemplate.update(MoneyQueries.UPDATE_PROFILE, params);
                profile.setId(existing.get().getId());
                profile.setUpdatedAt(now);
                profile.setCreatedAt(existing.get().getCreatedAt());
            } else {
                MapSqlParameterSource params = new MapSqlParameterSource()
                        .addValue("userId", profile.getUserId())
                        .addValue("currency", profile.getCurrency())
                        .addValue("reportedBalance", profile.getReportedBalance())
                        .addValue("emergencyReserve", profile.getEmergencyReserve())
                        .addValue("minimumCashReserve", profile.getMinimumCashReserve())
                        .addValue("weekStartDay", profile.getWeekStartDay())
                        .addValue("timezone", profile.getTimezone())
                        .addValue("defaultCarryForward", profile.getDefaultCarryForward() != null ? profile.getDefaultCarryForward().name() : "UNSPENT_ONLY")
                        .addValue("createdAt", Timestamp.from(now))
                        .addValue("updatedAt", Timestamp.from(now));
                KeyHolder keyHolder = new GeneratedKeyHolder();
                jdbcTemplate.update(MoneyQueries.CREATE_PROFILE, params, keyHolder, new String[]{"id"});
                Number key = keyHolder.getKey();
                if (key != null) profile.setId(key.longValue());
                profile.setCreatedAt(now);
                profile.setUpdatedAt(now);
            }
            return profile;
        });
    }

    @Override
    public Optional<FinancialProfile> findProfileByUserId(Long userId) {
        if (userId == null) return Optional.empty();
        return execute("find financial profile by user id", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource("userId", userId);
            List<FinancialProfile> list = jdbcTemplate.query(MoneyQueries.FIND_PROFILE_BY_USER_ID, params, profileRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        });
    }

    // =========================================================================
    // Income Sources
    // =========================================================================

    @Override
    public IncomeSource saveIncomeSource(IncomeSource source) {
        return execute("save income source", () -> {
            Instant now = Instant.now();
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", source.getUserId())
                    .addValue("sourceName", source.getSourceName())
                    .addValue("amount", source.getAmount())
                    .addValue("frequency", source.getFrequency() != null ? source.getFrequency().name() : "MONTHLY")
                    .addValue("expectedDayOfMonth", source.getExpectedDayOfMonth())
                    .addValue("active", source.isActive())
                    .addValue("notes", source.getNotes())
                    .addValue("createdAt", Timestamp.from(now))
                    .addValue("updatedAt", Timestamp.from(now));
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(MoneyQueries.CREATE_INCOME_SOURCE, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) source.setId(key.longValue());
            source.setCreatedAt(now);
            source.setUpdatedAt(now);
            return source;
        });
    }

    @Override
    public List<IncomeSource> findIncomeSourcesByUserId(Long userId) {
        if (userId == null) return Collections.emptyList();
        return execute("find income sources by user id", () ->
            jdbcTemplate.query(MoneyQueries.FIND_INCOME_SOURCES_BY_USER_ID, new MapSqlParameterSource("userId", userId), incomeSourceRowMapper)
        );
    }

    @Override
    public Optional<IncomeSource> findIncomeSourceById(Long id, Long userId) {
        if (id == null || userId == null) return Optional.empty();
        return execute("find income source by id", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            List<IncomeSource> list = jdbcTemplate.query(MoneyQueries.FIND_INCOME_SOURCE_BY_ID, params, incomeSourceRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        });
    }

    @Override
    public boolean deleteIncomeSource(Long id, Long userId) {
        return execute("delete income source", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            return jdbcTemplate.update(MoneyQueries.DELETE_INCOME_SOURCE, params) > 0;
        });
    }

    // =========================================================================
    // Categories
    // =========================================================================

    @Override
    public ExpenseCategory saveCategory(ExpenseCategory category) {
        return execute("save expense category", () -> {
            Instant now = Instant.now();
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", category.getUserId())
                    .addValue("name", category.getName())
                    .addValue("icon", category.getIcon())
                    .addValue("color", category.getColor())
                    .addValue("essential", category.isEssential())
                    .addValue("system", category.isSystem())
                    .addValue("createdAt", Timestamp.from(now));
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(MoneyQueries.CREATE_CATEGORY, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) category.setId(key.longValue());
            category.setCreatedAt(now);
            return category;
        });
    }

    @Override
    public List<ExpenseCategory> findCategoriesByUserId(Long userId) {
        return execute("find categories by user id", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource("userId", userId);
            return jdbcTemplate.query(MoneyQueries.FIND_CATEGORIES_FOR_USER, params, categoryRowMapper);
        });
    }

    @Override
    public Optional<ExpenseCategory> findCategoryByName(String name, Long userId) {
        return execute("find category by name", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("name", name).addValue("userId", userId);
            List<ExpenseCategory> list = jdbcTemplate.query(MoneyQueries.FIND_CATEGORY_BY_NAME, params, categoryRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        });
    }

    // =========================================================================
    // Financial Commitments
    // =========================================================================

    @Override
    public FinancialCommitment saveCommitment(FinancialCommitment commitment) {
        return execute("save financial commitment", () -> {
            Instant now = Instant.now();
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", commitment.getUserId())
                    .addValue("title", commitment.getTitle())
                    .addValue("commitmentType", commitment.getCommitmentType() != null ? commitment.getCommitmentType().name() : "OTHER")
                    .addValue("amount", commitment.getAmount())
                    .addValue("dueDayOfMonth", commitment.getDueDayOfMonth())
                    .addValue("frequency", commitment.getFrequency() != null ? commitment.getFrequency() : "MONTHLY")
                    .addValue("essential", commitment.isEssential())
                    .addValue("active", commitment.isActive())
                    .addValue("notes", commitment.getNotes())
                    .addValue("createdAt", Timestamp.from(now))
                    .addValue("updatedAt", Timestamp.from(now));
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(MoneyQueries.CREATE_COMMITMENT, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) commitment.setId(key.longValue());
            commitment.setCreatedAt(now);
            commitment.setUpdatedAt(now);
            return commitment;
        });
    }

    @Override
    public List<FinancialCommitment> findCommitmentsByUserId(Long userId) {
        if (userId == null) return Collections.emptyList();
        return execute("find commitments by user id", () ->
            jdbcTemplate.query(MoneyQueries.FIND_COMMITMENTS_BY_USER_ID, new MapSqlParameterSource("userId", userId), commitmentRowMapper)
        );
    }

    @Override
    public Optional<FinancialCommitment> findCommitmentById(Long id, Long userId) {
        if (id == null || userId == null) return Optional.empty();
        return execute("find commitment by id", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            List<FinancialCommitment> list = jdbcTemplate.query(MoneyQueries.FIND_COMMITMENT_BY_ID, params, commitmentRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        });
    }

    @Override
    public boolean deleteCommitment(Long id, Long userId) {
        return execute("delete commitment", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            return jdbcTemplate.update(MoneyQueries.DELETE_COMMITMENT, params) > 0;
        });
    }

    // =========================================================================
    // Savings Goals
    // =========================================================================

    @Override
    public SavingsGoal saveSavingsGoal(SavingsGoal goal) {
        return execute("save savings goal", () -> {
            Instant now = Instant.now();
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", goal.getUserId())
                    .addValue("title", goal.getTitle())
                    .addValue("targetAmount", goal.getTargetAmount())
                    .addValue("currentAmount", goal.getCurrentAmount())
                    .addValue("monthlyContribution", goal.getMonthlyContribution())
                    .addValue("targetDate", goal.getTargetDate() != null ? Date.valueOf(goal.getTargetDate()) : null)
                    .addValue("active", goal.isActive())
                    .addValue("createdAt", Timestamp.from(now))
                    .addValue("updatedAt", Timestamp.from(now));
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(MoneyQueries.CREATE_SAVINGS_GOAL, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) goal.setId(key.longValue());
            goal.setCreatedAt(now);
            goal.setUpdatedAt(now);
            return goal;
        });
    }

    @Override
    public SavingsGoal updateSavingsGoal(SavingsGoal goal) {
        return execute("update savings goal", () -> {
            Instant now = Instant.now();
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("id", goal.getId())
                    .addValue("userId", goal.getUserId())
                    .addValue("title", goal.getTitle())
                    .addValue("targetAmount", goal.getTargetAmount())
                    .addValue("currentAmount", goal.getCurrentAmount())
                    .addValue("monthlyContribution", goal.getMonthlyContribution())
                    .addValue("targetDate", goal.getTargetDate() != null ? Date.valueOf(goal.getTargetDate()) : null)
                    .addValue("active", goal.isActive())
                    .addValue("updatedAt", Timestamp.from(now));
            jdbcTemplate.update(MoneyQueries.UPDATE_SAVINGS_GOAL, params);
            goal.setUpdatedAt(now);
            return goal;
        });
    }

    @Override
    public List<SavingsGoal> findSavingsGoalsByUserId(Long userId) {
        if (userId == null) return Collections.emptyList();
        return execute("find savings goals by user id", () ->
            jdbcTemplate.query(MoneyQueries.FIND_SAVINGS_GOALS_BY_USER_ID, new MapSqlParameterSource("userId", userId), savingsGoalRowMapper)
        );
    }

    @Override
    public Optional<SavingsGoal> findSavingsGoalById(Long id, Long userId) {
        if (id == null || userId == null) return Optional.empty();
        return execute("find savings goal by id", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            List<SavingsGoal> list = jdbcTemplate.query(MoneyQueries.FIND_SAVINGS_GOAL_BY_ID, params, savingsGoalRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        });
    }

    @Override
    public boolean deleteSavingsGoal(Long id, Long userId) {
        return execute("delete savings goal", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            return jdbcTemplate.update(MoneyQueries.DELETE_SAVINGS_GOAL, params) > 0;
        });
    }

    // =========================================================================
    // Budget Plans
    // =========================================================================

    @Override
    public BudgetPlan saveBudgetPlan(BudgetPlan plan) {
        return execute("save budget plan", () -> {
            Instant now = Instant.now();
            if (plan.isActive()) {
                jdbcTemplate.update(MoneyQueries.DEACTIVATE_OTHER_PLANS, new MapSqlParameterSource("userId", plan.getUserId()));
            }
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", plan.getUserId())
                    .addValue("periodType", plan.getPeriodType() != null ? plan.getPeriodType().name() : "MONTHLY")
                    .addValue("startDate", Date.valueOf(plan.getStartDate()))
                    .addValue("endDate", Date.valueOf(plan.getEndDate()))
                    .addValue("totalBudget", plan.getTotalBudget())
                    .addValue("carryForwardRule", plan.getCarryForwardRule() != null ? plan.getCarryForwardRule().name() : "UNSPENT_ONLY")
                    .addValue("carriedForwardAmount", plan.getCarriedForwardAmount())
                    .addValue("active", plan.isActive())
                    .addValue("notes", plan.getNotes())
                    .addValue("createdAt", Timestamp.from(now))
                    .addValue("updatedAt", Timestamp.from(now));
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(MoneyQueries.CREATE_BUDGET_PLAN, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) plan.setId(key.longValue());
            plan.setCreatedAt(now);
            plan.setUpdatedAt(now);

            if (plan.getCategoryLimits() != null && !plan.getCategoryLimits().isEmpty()) {
                saveCategoryLimits(plan.getId(), plan.getCategoryLimits());
            }
            return plan;
        });
    }

    @Override
    public Optional<BudgetPlan> findActiveBudgetPlan(Long userId) {
        if (userId == null) return Optional.empty();
        return execute("find active budget plan", () -> {
            List<BudgetPlan> list = jdbcTemplate.query(MoneyQueries.FIND_ACTIVE_BUDGET_PLAN, new MapSqlParameterSource("userId", userId), budgetPlanRowMapper);
            if (list.isEmpty()) return Optional.empty();
            BudgetPlan plan = list.get(0);
            plan.setCategoryLimits(findCategoryLimitsByPlanId(plan.getId()));
            return Optional.of(plan);
        });
    }

    @Override
    public List<BudgetPlan> findBudgetPlansByUserId(Long userId) {
        if (userId == null) return Collections.emptyList();
        return execute("find budget plans by user id", () -> {
            List<BudgetPlan> list = jdbcTemplate.query(MoneyQueries.FIND_BUDGET_PLANS_BY_USER_ID, new MapSqlParameterSource("userId", userId), budgetPlanRowMapper);
            for (BudgetPlan p : list) {
                p.setCategoryLimits(findCategoryLimitsByPlanId(p.getId()));
            }
            return list;
        });
    }

    @Override
    public Optional<BudgetPlan> findBudgetPlanById(Long id, Long userId) {
        if (id == null || userId == null) return Optional.empty();
        return execute("find budget plan by id", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            List<BudgetPlan> list = jdbcTemplate.query(MoneyQueries.FIND_BUDGET_PLAN_BY_ID, params, budgetPlanRowMapper);
            if (list.isEmpty()) return Optional.empty();
            BudgetPlan plan = list.get(0);
            plan.setCategoryLimits(findCategoryLimitsByPlanId(plan.getId()));
            return Optional.of(plan);
        });
    }

    @Override
    public boolean deleteBudgetPlan(Long id, Long userId) {
        return execute("delete budget plan", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            return jdbcTemplate.update(MoneyQueries.DELETE_BUDGET_PLAN, params) > 0;
        });
    }

    @Override
    public void saveCategoryLimits(Long planId, List<BudgetCategoryLimit> limits) {
        executeAction("save category limits", () -> {
            jdbcTemplate.update(MoneyQueries.DELETE_CATEGORY_LIMITS_BY_PLAN, new MapSqlParameterSource("budgetPlanId", planId));
            for (BudgetCategoryLimit l : limits) {
                MapSqlParameterSource params = new MapSqlParameterSource()
                        .addValue("budgetPlanId", planId)
                        .addValue("categoryName", l.getCategoryName())
                        .addValue("allocatedAmount", l.getAllocatedAmount())
                        .addValue("essential", l.isEssential());
                jdbcTemplate.update(MoneyQueries.CREATE_CATEGORY_LIMIT, params);
            }
        });
    }

    @Override
    public List<BudgetCategoryLimit> findCategoryLimitsByPlanId(Long planId) {
        return execute("find category limits by plan id", () ->
            jdbcTemplate.query(MoneyQueries.FIND_CATEGORY_LIMITS_BY_PLAN, new MapSqlParameterSource("budgetPlanId", planId), categoryLimitRowMapper)
        );
    }

    // =========================================================================
    // Planned Expenses
    // =========================================================================

    @Override
    public PlannedExpense savePlannedExpense(PlannedExpense expense) {
        return execute("save planned expense", () -> {
            Instant now = Instant.now();
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", expense.getUserId())
                    .addValue("title", expense.getTitle())
                    .addValue("amount", expense.getAmount())
                    .addValue("plannedDate", Date.valueOf(expense.getPlannedDate()))
                    .addValue("categoryName", expense.getCategoryName())
                    .addValue("essential", expense.isEssential())
                    .addValue("executed", expense.isExecuted())
                    .addValue("notes", expense.getNotes())
                    .addValue("createdAt", Timestamp.from(now))
                    .addValue("updatedAt", Timestamp.from(now));
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(MoneyQueries.CREATE_PLANNED_EXPENSE, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) expense.setId(key.longValue());
            expense.setCreatedAt(now);
            expense.setUpdatedAt(now);
            return expense;
        });
    }

    @Override
    public void markPlannedExpenseExecuted(Long id, Long userId, Long transactionId) {
        executeAction("mark planned expense executed", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("id", id)
                    .addValue("userId", userId)
                    .addValue("transactionId", transactionId)
                    .addValue("updatedAt", Timestamp.from(Instant.now()));
            jdbcTemplate.update(MoneyQueries.UPDATE_PLANNED_EXPENSE_EXECUTED, params);
        });
    }

    @Override
    public List<PlannedExpense> findPlannedExpensesByUserId(Long userId) {
        if (userId == null) return Collections.emptyList();
        return execute("find planned expenses by user id", () ->
            jdbcTemplate.query(MoneyQueries.FIND_PLANNED_EXPENSES_BY_USER_ID, new MapSqlParameterSource("userId", userId), plannedExpenseRowMapper)
        );
    }

    @Override
    public List<PlannedExpense> findUpcomingPlannedExpenses(Long userId, LocalDate fromDate, LocalDate toDate) {
        return execute("find upcoming planned expenses", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", userId)
                    .addValue("fromDate", Date.valueOf(fromDate))
                    .addValue("toDate", Date.valueOf(toDate));
            return jdbcTemplate.query(MoneyQueries.FIND_UPCOMING_PLANNED_EXPENSES, params, plannedExpenseRowMapper);
        });
    }

    @Override
    public Optional<PlannedExpense> findPlannedExpenseById(Long id, Long userId) {
        if (id == null || userId == null) return Optional.empty();
        return execute("find planned expense by id", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            List<PlannedExpense> list = jdbcTemplate.query(MoneyQueries.FIND_PLANNED_EXPENSE_BY_ID, params, plannedExpenseRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        });
    }

    @Override
    public boolean deletePlannedExpense(Long id, Long userId) {
        return execute("delete planned expense", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            return jdbcTemplate.update(MoneyQueries.DELETE_PLANNED_EXPENSE, params) > 0;
        });
    }

    // =========================================================================
    // Recurring Schedules & Occurrences
    // =========================================================================

    @Override
    public RecurringSchedule saveRecurringSchedule(RecurringSchedule schedule) {
        return execute("save recurring schedule", () -> {
            Instant now = Instant.now();
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", schedule.getUserId())
                    .addValue("title", schedule.getTitle())
                    .addValue("transactionType", schedule.getTransactionType() != null ? schedule.getTransactionType().name() : "EXPENSE")
                    .addValue("categoryName", schedule.getCategoryName())
                    .addValue("amount", schedule.getAmount())
                    .addValue("frequency", schedule.getFrequency() != null ? schedule.getFrequency().name() : "MONTHLY")
                    .addValue("startDate", Date.valueOf(schedule.getStartDate()))
                    .addValue("endDate", schedule.getEndDate() != null ? Date.valueOf(schedule.getEndDate()) : null)
                    .addValue("dayOfMonth", schedule.getDayOfMonth())
                    .addValue("dayOfWeek", schedule.getDayOfWeek())
                    .addValue("essential", schedule.isEssential())
                    .addValue("paymentMethod", schedule.getPaymentMethod() != null ? schedule.getPaymentMethod().name() : "UPI")
                    .addValue("active", schedule.isActive())
                    .addValue("lastGeneratedDate", schedule.getLastGeneratedDate() != null ? Date.valueOf(schedule.getLastGeneratedDate()) : null)
                    .addValue("createdAt", Timestamp.from(now))
                    .addValue("updatedAt", Timestamp.from(now));
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(MoneyQueries.CREATE_RECURRING_SCHEDULE, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) schedule.setId(key.longValue());
            schedule.setCreatedAt(now);
            schedule.setUpdatedAt(now);
            return schedule;
        });
    }

    @Override
    public List<RecurringSchedule> findRecurringSchedulesByUserId(Long userId) {
        if (userId == null) return Collections.emptyList();
        return execute("find recurring schedules by user id", () ->
            jdbcTemplate.query(MoneyQueries.FIND_RECURRING_SCHEDULES_BY_USER_ID, new MapSqlParameterSource("userId", userId), recurringScheduleRowMapper)
        );
    }

    @Override
    public Optional<RecurringSchedule> findRecurringScheduleById(Long id, Long userId) {
        if (id == null || userId == null) return Optional.empty();
        return execute("find recurring schedule by id", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            List<RecurringSchedule> list = jdbcTemplate.query(MoneyQueries.FIND_RECURRING_SCHEDULE_BY_ID, params, recurringScheduleRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        });
    }

    @Override
    public boolean deleteRecurringSchedule(Long id, Long userId) {
        return execute("delete recurring schedule", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            return jdbcTemplate.update(MoneyQueries.DELETE_RECURRING_SCHEDULE, params) > 0;
        });
    }

    @Override
    public List<RecurringSchedule> findActiveRecurringSchedules() {
        return execute("find active recurring schedules", () ->
            jdbcTemplate.query(MoneyQueries.FIND_ACTIVE_RECURRING_SCHEDULES, recurringScheduleRowMapper)
        );
    }

    @Override
    public void updateScheduleLastGenerated(Long scheduleId, LocalDate lastGeneratedDate) {
        executeAction("update schedule last generated", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("id", scheduleId)
                    .addValue("lastGeneratedDate", Date.valueOf(lastGeneratedDate))
                    .addValue("updatedAt", Timestamp.from(Instant.now()));
            jdbcTemplate.update(MoneyQueries.UPDATE_SCHEDULE_LAST_GENERATED, params);
        });
    }

    @Override
    public RecurringOccurrence saveOccurrence(RecurringOccurrence occurrence) {
        return execute("save recurring occurrence", () -> {
            Instant now = Instant.now();
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("scheduleId", occurrence.getScheduleId())
                    .addValue("userId", occurrence.getUserId())
                    .addValue("scheduledDate", Date.valueOf(occurrence.getScheduledDate()))
                    .addValue("amount", occurrence.getAmount())
                    .addValue("status", occurrence.getStatus() != null ? occurrence.getStatus().name() : "PENDING")
                    .addValue("createdAt", Timestamp.from(now))
                    .addValue("updatedAt", Timestamp.from(now));
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(MoneyQueries.CREATE_OCCURRENCE, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) occurrence.setId(key.longValue());
            occurrence.setCreatedAt(now);
            occurrence.setUpdatedAt(now);
            return occurrence;
        });
    }

    @Override
    public Optional<RecurringOccurrence> findOccurrenceById(Long id, Long userId) {
        if (id == null || userId == null) return Optional.empty();
        return execute("find recurring occurrence by id", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            List<RecurringOccurrence> list = jdbcTemplate.query(MoneyQueries.FIND_OCCURRENCE_BY_ID, params, occurrenceRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        });
    }

    @Override
    public List<RecurringOccurrence> findOccurrencesByUserAndRange(Long userId, LocalDate fromDate, LocalDate toDate) {
        return execute("find occurrences by user and date range", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", userId)
                    .addValue("fromDate", Date.valueOf(fromDate))
                    .addValue("toDate", Date.valueOf(toDate));
            return jdbcTemplate.query(MoneyQueries.FIND_OCCURRENCES_BY_USER_AND_DATE_RANGE, params, occurrenceRowMapper);
        });
    }

    @Override
    public void markOccurrenceProcessed(Long id, Long userId, Long transactionId) {
        executeAction("mark occurrence processed", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("id", id)
                    .addValue("userId", userId)
                    .addValue("transactionId", transactionId)
                    .addValue("updatedAt", Timestamp.from(Instant.now()));
            jdbcTemplate.update(MoneyQueries.UPDATE_OCCURRENCE_PROCESSED, params);
        });
    }

    // =========================================================================
    // Financial Transactions
    // =========================================================================

    @Override
    public FinancialTransaction saveTransaction(FinancialTransaction transaction) {
        return execute("save financial transaction", () -> {
            Instant now = Instant.now();
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", transaction.getUserId())
                    .addValue("transactionType", transaction.getTransactionType() != null ? transaction.getTransactionType().name() : "EXPENSE")
                    .addValue("categoryName", transaction.getCategoryName())
                    .addValue("subCategory", transaction.getSubCategory())
                    .addValue("amount", transaction.getAmount())
                    .addValue("currency", transaction.getCurrency() != null ? transaction.getCurrency() : "INR")
                    .addValue("paymentMethod", transaction.getPaymentMethod() != null ? transaction.getPaymentMethod().name() : "UPI")
                    .addValue("transactionDate", Timestamp.from(transaction.getTransactionDate() != null ? transaction.getTransactionDate() : now))
                    .addValue("essential", transaction.isEssential())
                    .addValue("idempotencyKey", transaction.getIdempotencyKey())
                    .addValue("notes", transaction.getNotes())
                    .addValue("plannedExpenseId", transaction.getPlannedExpenseId())
                    .addValue("recurringOccurrenceId", transaction.getRecurringOccurrenceId())
                    .addValue("createdAt", Timestamp.from(now))
                    .addValue("updatedAt", Timestamp.from(now));
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(MoneyQueries.CREATE_TRANSACTION, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) transaction.setId(key.longValue());
            transaction.setCreatedAt(now);
            transaction.setUpdatedAt(now);
            return transaction;
        });
    }

    @Override
    public Optional<FinancialTransaction> findTransactionById(Long id, Long userId) {
        if (id == null || userId == null) return Optional.empty();
        return execute("find transaction by id", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            List<FinancialTransaction> list = jdbcTemplate.query(MoneyQueries.FIND_TRANSACTION_BY_ID, params, transactionRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        });
    }

    @Override
    public Optional<FinancialTransaction> findTransactionByIdempotencyKey(Long userId, String idempotencyKey) {
        if (userId == null || idempotencyKey == null || idempotencyKey.isBlank()) return Optional.empty();
        return execute("find transaction by idempotency key", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("userId", userId).addValue("idempotencyKey", idempotencyKey.trim());
            List<FinancialTransaction> list = jdbcTemplate.query(MoneyQueries.FIND_TRANSACTION_BY_IDEMPOTENCY_KEY, params, transactionRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        });
    }

    @Override
    public List<FinancialTransaction> findTransactions(Long userId, String type, String category, Instant fromDate, Instant toDate, int limit, int offset) {
        return execute("find transactions", () -> {
            StringBuilder sql = new StringBuilder("SELECT * FROM financial_transactions WHERE user_id = :userId");
            MapSqlParameterSource params = new MapSqlParameterSource("userId", userId);

            if (type != null && !type.isBlank()) {
                sql.append(" AND transaction_type = :type");
                params.addValue("type", type.trim().toUpperCase());
            }
            if (category != null && !category.isBlank()) {
                sql.append(" AND LOWER(category_name) = LOWER(:category)");
                params.addValue("category", category.trim());
            }
            if (fromDate != null) {
                sql.append(" AND transaction_date >= :fromDate");
                params.addValue("fromDate", Timestamp.from(fromDate));
            }
            if (toDate != null) {
                sql.append(" AND transaction_date <= :toDate");
                params.addValue("toDate", Timestamp.from(toDate));
            }
            sql.append(" ORDER BY transaction_date DESC LIMIT :limit OFFSET :offset");
            params.addValue("limit", limit > 0 ? limit : 50);
            params.addValue("offset", Math.max(offset, 0));

            return jdbcTemplate.query(sql.toString(), params, transactionRowMapper);
        });
    }

    @Override
    public boolean deleteTransaction(Long id, Long userId) {
        return execute("delete transaction", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            return jdbcTemplate.update(MoneyQueries.DELETE_TRANSACTION, params) > 0;
        });
    }

    @Override
    public BigDecimal sumExpensesToday(Long userId, Instant startOfDay, Instant endOfDay) {
        return execute("sum expenses today", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", userId)
                    .addValue("startOfDay", Timestamp.from(startOfDay))
                    .addValue("endOfDay", Timestamp.from(endOfDay));
            BigDecimal sum = jdbcTemplate.queryForObject(MoneyQueries.SUM_EXPENSES_TODAY, params, BigDecimal.class);
            return sum != null ? sum : BigDecimal.ZERO;
        });
    }

    @Override
    public BigDecimal sumByTypeAndRange(Long userId, String type, Instant fromDate, Instant toDate) {
        return execute("sum by type and range", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", userId)
                    .addValue("type", type)
                    .addValue("startDate", Timestamp.from(fromDate))
                    .addValue("endDate", Timestamp.from(toDate));
            BigDecimal sum = jdbcTemplate.queryForObject(MoneyQueries.SUM_BY_TYPE_AND_RANGE, params, BigDecimal.class);
            return sum != null ? sum : BigDecimal.ZERO;
        });
    }

    @Override
    public BigDecimal sumExpensesByEssential(Long userId, boolean essential, Instant fromDate, Instant toDate) {
        return execute("sum expenses by essential", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", userId)
                    .addValue("essential", essential)
                    .addValue("startDate", Timestamp.from(fromDate))
                    .addValue("endDate", Timestamp.from(toDate));
            BigDecimal sum = jdbcTemplate.queryForObject(MoneyQueries.SUM_EXPENSES_BY_ESSENTIAL, params, BigDecimal.class);
            return sum != null ? sum : BigDecimal.ZERO;
        });
    }

    @Override
    public Map<String, BigDecimal> getExpensesByCategoryInRange(Long userId, Instant fromDate, Instant toDate) {
        return execute("get expenses by category in range", () -> {
            String sql = "SELECT category_name, COALESCE(SUM(amount), 0) as total FROM financial_transactions " +
                         "WHERE user_id = :userId AND transaction_type = 'EXPENSE' AND transaction_date >= :fromDate AND transaction_date <= :toDate " +
                         "GROUP BY category_name";
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", userId)
                    .addValue("fromDate", Timestamp.from(fromDate))
                    .addValue("toDate", Timestamp.from(toDate));

            Map<String, BigDecimal> result = new LinkedHashMap<>();
            jdbcTemplate.query(sql, params, rs -> {
                result.put(rs.getString("category_name"), rs.getBigDecimal("total"));
            });
            return result;
        });
    }

    @Override
    public long countTransactions(Long userId, String type, String category, Instant fromDate, Instant toDate) {
        return execute("count transactions", () -> {
            StringBuilder sql = new StringBuilder("SELECT COUNT(1) FROM financial_transactions WHERE user_id = :userId");
            MapSqlParameterSource params = new MapSqlParameterSource("userId", userId);
            if (type != null && !type.isBlank()) {
                sql.append(" AND transaction_type = :type");
                params.addValue("type", type.trim().toUpperCase());
            }
            if (category != null && !category.isBlank()) {
                sql.append(" AND LOWER(category_name) = LOWER(:category)");
                params.addValue("category", category.trim());
            }
            if (fromDate != null) {
                sql.append(" AND transaction_date >= :fromDate");
                params.addValue("fromDate", Timestamp.from(fromDate));
            }
            if (toDate != null) {
                sql.append(" AND transaction_date <= :toDate");
                params.addValue("toDate", Timestamp.from(toDate));
            }
            Long count = jdbcTemplate.queryForObject(sql.toString(), params, Long.class);
            return count != null ? count : 0L;
        });
    }

    // =========================================================================
    // Reminder Preferences & Notifications
    // =========================================================================

    @Override
    public ReminderPreference saveReminderPreference(ReminderPreference pref) {
        return execute("save reminder preference", () -> {
            Instant now = Instant.now();
            Optional<ReminderPreference> existing = findReminderPreferenceByUserId(pref.getUserId());
            if (existing.isPresent()) {
                MapSqlParameterSource params = new MapSqlParameterSource()
                        .addValue("userId", pref.getUserId())
                        .addValue("dailyBudgetReminderEnabled", pref.isDailyBudgetReminderEnabled())
                        .addValue("dailyReminderTime", pref.getDailyReminderTime())
                        .addValue("billDueReminderDaysBefore", pref.getBillDueReminderDaysBefore())
                        .addValue("budgetThresholdWarningEnabled", pref.isBudgetThresholdWarningEnabled())
                        .addValue("budgetThresholdPercent", pref.getBudgetThresholdPercent())
                        .addValue("quietHoursStart", pref.getQuietHoursStart())
                        .addValue("quietHoursEnd", pref.getQuietHoursEnd())
                        .addValue("notificationChannel", pref.getNotificationChannel() != null ? pref.getNotificationChannel().name() : "PUSH")
                        .addValue("updatedAt", Timestamp.from(now));
                jdbcTemplate.update(MoneyQueries.UPDATE_REMINDER_PREFERENCE, params);
                pref.setId(existing.get().getId());
                pref.setUpdatedAt(now);
                pref.setCreatedAt(existing.get().getCreatedAt());
            } else {
                MapSqlParameterSource params = new MapSqlParameterSource()
                        .addValue("userId", pref.getUserId())
                        .addValue("dailyBudgetReminderEnabled", pref.isDailyBudgetReminderEnabled())
                        .addValue("dailyReminderTime", pref.getDailyReminderTime())
                        .addValue("billDueReminderDaysBefore", pref.getBillDueReminderDaysBefore())
                        .addValue("budgetThresholdWarningEnabled", pref.isBudgetThresholdWarningEnabled())
                        .addValue("budgetThresholdPercent", pref.getBudgetThresholdPercent())
                        .addValue("quietHoursStart", pref.getQuietHoursStart())
                        .addValue("quietHoursEnd", pref.getQuietHoursEnd())
                        .addValue("notificationChannel", pref.getNotificationChannel() != null ? pref.getNotificationChannel().name() : "PUSH")
                        .addValue("createdAt", Timestamp.from(now))
                        .addValue("updatedAt", Timestamp.from(now));
                KeyHolder keyHolder = new GeneratedKeyHolder();
                jdbcTemplate.update(MoneyQueries.CREATE_REMINDER_PREFERENCE, params, keyHolder, new String[]{"id"});
                Number key = keyHolder.getKey();
                if (key != null) pref.setId(key.longValue());
                pref.setCreatedAt(now);
                pref.setUpdatedAt(now);
            }
            return pref;
        });
    }

    @Override
    public Optional<ReminderPreference> findReminderPreferenceByUserId(Long userId) {
        if (userId == null) return Optional.empty();
        return execute("find reminder preference by user id", () -> {
            List<ReminderPreference> list = jdbcTemplate.query(MoneyQueries.FIND_REMINDER_PREFERENCE_BY_USER_ID, new MapSqlParameterSource("userId", userId), reminderPreferenceRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        });
    }

    @Override
    public UserNotification saveNotification(UserNotification notification) {
        return execute("save notification", () -> {
            Instant now = Instant.now();
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", notification.getUserId())
                    .addValue("title", notification.getTitle())
                    .addValue("message", notification.getMessage())
                    .addValue("notificationType", notification.getNotificationType() != null ? notification.getNotificationType().name() : "SYSTEM")
                    .addValue("read", notification.isRead())
                    .addValue("scheduledAt", Timestamp.from(notification.getScheduledAt() != null ? notification.getScheduledAt() : now))
                    .addValue("createdAt", Timestamp.from(now));
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(MoneyQueries.CREATE_NOTIFICATION, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) notification.setId(key.longValue());
            notification.setCreatedAt(now);
            return notification;
        });
    }

    @Override
    public List<UserNotification> findNotificationsByUserId(Long userId, int limit) {
        if (userId == null) return Collections.emptyList();
        return execute("find notifications by user id", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("userId", userId).addValue("limit", limit > 0 ? limit : 20);
            return jdbcTemplate.query(MoneyQueries.FIND_NOTIFICATIONS_BY_USER_ID, params, notificationRowMapper);
        });
    }

    @Override
    public boolean markNotificationRead(Long id, Long userId) {
        return execute("mark notification read", () -> {
            MapSqlParameterSource params = new MapSqlParameterSource().addValue("id", id).addValue("userId", userId);
            return jdbcTemplate.update(MoneyQueries.MARK_NOTIFICATION_READ, params) > 0;
        });
    }
}
