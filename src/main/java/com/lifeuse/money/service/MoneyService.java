package com.lifeuse.money.service;

import com.lifeuse.common.ApiResponse;
import com.lifeuse.common.BusinessException;
import com.lifeuse.common.ResourceNotFoundException;
import com.lifeuse.common.exception.DatabaseOperationException;
import com.lifeuse.money.models.dto.*;
import com.lifeuse.money.models.entity.*;
import com.lifeuse.money.models.enums.*;
import com.lifeuse.money.models.mapper.MoneyDtoMapper;
import com.lifeuse.money.repository.IMoneyRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneOffset;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class MoneyService implements IMoneyService {

    private final IMoneyRepository moneyRepository;
    private final IMoneyCalculationService calculationService;

    public MoneyService(IMoneyRepository moneyRepository, IMoneyCalculationService calculationService) {
        this.moneyRepository = moneyRepository;
        this.calculationService = calculationService;
    }

    // =========================================================================
    // Financial Profile
    // =========================================================================

    @Override
    public FinancialProfileResponse getProfile(Long userId) {
        try {
            FinancialProfile profile = moneyRepository.findProfileByUserId(userId)
                    .orElseGet(() -> {
                        FinancialProfile defaultProfile = new FinancialProfile();
                        defaultProfile.setUserId(userId);
                        return moneyRepository.saveProfile(defaultProfile);
                    });
            return MoneyDtoMapper.toProfileResponse(profile);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve financial profile", ex);
        }
    }

    @Override
    @Transactional
    public FinancialProfileResponse updateProfile(Long userId, FinancialProfileRequest request) {
        try {
            FinancialProfile profile = moneyRepository.findProfileByUserId(userId)
                    .orElseGet(() -> {
                        FinancialProfile p = new FinancialProfile();
                        p.setUserId(userId);
                        return p;
                    });

            if (request.getCurrency() != null) profile.setCurrency(request.getCurrency().trim().toUpperCase());
            if (request.getReportedBalance() != null) profile.setReportedBalance(request.getReportedBalance());
            if (request.getEmergencyReserve() != null) profile.setEmergencyReserve(request.getEmergencyReserve());
            if (request.getMinimumCashReserve() != null) profile.setMinimumCashReserve(request.getMinimumCashReserve());
            if (request.getWeekStartDay() != null) profile.setWeekStartDay(request.getWeekStartDay());
            if (request.getTimezone() != null) profile.setTimezone(request.getTimezone());
            if (request.getDefaultCarryForward() != null) profile.setDefaultCarryForward(request.getDefaultCarryForward());

            FinancialProfile saved = moneyRepository.saveProfile(profile);
            return MoneyDtoMapper.toProfileResponse(saved);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to update financial profile", ex);
        }
    }

    // =========================================================================
    // Income Sources
    // =========================================================================

    @Override
    public List<IncomeSourceResponse> getIncomeSources(Long userId) {
        try {
            return moneyRepository.findIncomeSourcesByUserId(userId).stream()
                    .map(MoneyDtoMapper::toIncomeSourceResponse)
                    .collect(Collectors.toList());
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve income sources", ex);
        }
    }

    @Override
    @Transactional
    public IncomeSourceResponse addIncomeSource(Long userId, IncomeSourceRequest request) {
        try {
            IncomeSource source = new IncomeSource();
            source.setUserId(userId);
            source.setSourceName(request.getSourceName().trim());
            source.setAmount(request.getAmount());
            source.setFrequency(request.getFrequency());
            source.setExpectedDayOfMonth(request.getExpectedDayOfMonth());
            source.setActive(request.getActive() != null ? request.getActive() : true);
            source.setNotes(request.getNotes());

            IncomeSource saved = moneyRepository.saveIncomeSource(source);
            return MoneyDtoMapper.toIncomeSourceResponse(saved);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to add income source", ex);
        }
    }

    @Override
    @Transactional
    public void deleteIncomeSource(Long userId, Long id) {
        try {
            boolean deleted = moneyRepository.deleteIncomeSource(id, userId);
            if (!deleted) {
                throw new ResourceNotFoundException("Income source not found or does not belong to you");
            }
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to delete income source", ex);
        }
    }

    // =========================================================================
    // Categories
    // =========================================================================

    @Override
    public List<CategoryResponse> getCategories(Long userId) {
        try {
            return moneyRepository.findCategoriesByUserId(userId).stream()
                    .map(MoneyDtoMapper::toCategoryResponse)
                    .collect(Collectors.toList());
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve categories", ex);
        }
    }

    @Override
    @Transactional
    public CategoryResponse createCategory(Long userId, CategoryRequest request) {
        try {
            Optional<ExpenseCategory> existing = moneyRepository.findCategoryByName(request.getName().trim(), userId);
            if (existing.isPresent()) {
                return MoneyDtoMapper.toCategoryResponse(existing.get());
            }

            ExpenseCategory category = new ExpenseCategory();
            category.setUserId(userId);
            category.setName(request.getName().trim());
            category.setIcon(request.getIcon());
            category.setColor(request.getColor());
            category.setEssential(request.getEssential() != null ? request.getEssential() : false);
            category.setSystem(false);

            ExpenseCategory saved = moneyRepository.saveCategory(category);
            return MoneyDtoMapper.toCategoryResponse(saved);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to create category", ex);
        }
    }

    // =========================================================================
    // Commitments
    // =========================================================================

    @Override
    public List<FinancialCommitmentResponse> getCommitments(Long userId) {
        try {
            return moneyRepository.findCommitmentsByUserId(userId).stream()
                    .map(MoneyDtoMapper::toCommitmentResponse)
                    .collect(Collectors.toList());
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve financial commitments", ex);
        }
    }

    @Override
    @Transactional
    public FinancialCommitmentResponse addCommitment(Long userId, FinancialCommitmentRequest request) {
        try {
            FinancialCommitment commitment = new FinancialCommitment();
            commitment.setUserId(userId);
            commitment.setTitle(request.getTitle().trim());
            commitment.setCommitmentType(request.getCommitmentType());
            commitment.setAmount(request.getAmount());
            commitment.setDueDayOfMonth(request.getDueDayOfMonth());
            commitment.setFrequency(request.getFrequency() != null ? request.getFrequency() : "MONTHLY");
            commitment.setEssential(request.getEssential() != null ? request.getEssential() : true);
            commitment.setActive(request.getActive() != null ? request.getActive() : true);
            commitment.setNotes(request.getNotes());

            FinancialCommitment saved = moneyRepository.saveCommitment(commitment);
            return MoneyDtoMapper.toCommitmentResponse(saved);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to add financial commitment", ex);
        }
    }

    @Override
    @Transactional
    public void deleteCommitment(Long userId, Long id) {
        try {
            boolean deleted = moneyRepository.deleteCommitment(id, userId);
            if (!deleted) {
                throw new ResourceNotFoundException("Commitment not found or does not belong to you");
            }
        } catch (ResourceNotFoundException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to delete financial commitment", ex);
        }
    }

    // =========================================================================
    // Savings Goals
    // =========================================================================

    @Override
    public List<SavingsGoalResponse> getSavingsGoals(Long userId) {
        try {
            return moneyRepository.findSavingsGoalsByUserId(userId).stream()
                    .map(MoneyDtoMapper::toSavingsGoalResponse)
                    .collect(Collectors.toList());
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve savings goals", ex);
        }
    }

    @Override
    @Transactional
    public SavingsGoalResponse addSavingsGoal(Long userId, SavingsGoalRequest request) {
        try {
            SavingsGoal goal = new SavingsGoal();
            goal.setUserId(userId);
            goal.setTitle(request.getTitle().trim());
            goal.setTargetAmount(request.getTargetAmount());
            goal.setCurrentAmount(request.getCurrentAmount() != null ? request.getCurrentAmount() : BigDecimal.ZERO);
            goal.setMonthlyContribution(request.getMonthlyContribution() != null ? request.getMonthlyContribution() : BigDecimal.ZERO);
            goal.setTargetDate(request.getTargetDate());
            goal.setActive(request.getActive() != null ? request.getActive() : true);

            SavingsGoal saved = moneyRepository.saveSavingsGoal(goal);
            return MoneyDtoMapper.toSavingsGoalResponse(saved);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to add savings goal", ex);
        }
    }

    @Override
    @Transactional
    public void deleteSavingsGoal(Long userId, Long id) {
        try {
            boolean deleted = moneyRepository.deleteSavingsGoal(id, userId);
            if (!deleted) {
                throw new ResourceNotFoundException("Savings goal not found or does not belong to you");
            }
        } catch (ResourceNotFoundException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to delete savings goal", ex);
        }
    }

    // =========================================================================
    // Transactions
    // =========================================================================

    @Override
    @Transactional
    public TransactionResponse createTransaction(Long userId, TransactionCreateRequest request) {
        try {
            // Idempotency check: if key provided and already exists, return existing transaction
            if (request.getIdempotencyKey() != null && !request.getIdempotencyKey().isBlank()) {
                Optional<FinancialTransaction> existing = moneyRepository.findTransactionByIdempotencyKey(userId, request.getIdempotencyKey().trim());
                if (existing.isPresent()) {
                    return MoneyDtoMapper.toTransactionResponse(existing.get());
                }
            }

            FinancialTransaction tx = new FinancialTransaction();
            tx.setUserId(userId);
            tx.setTransactionType(request.getTransactionType());
            tx.setCategoryName(request.getCategoryName().trim());
            tx.setSubCategory(request.getSubCategory());
            tx.setAmount(request.getAmount());
            tx.setCurrency(request.getCurrency() != null ? request.getCurrency().trim().toUpperCase() : "INR");
            tx.setPaymentMethod(request.getPaymentMethod() != null ? request.getPaymentMethod() : PaymentMethod.UPI);
            tx.setTransactionDate(request.getTransactionDate() != null ? request.getTransactionDate() : Instant.now());
            tx.setEssential(request.getEssential() != null ? request.getEssential() : false);
            tx.setIdempotencyKey(request.getIdempotencyKey());
            tx.setNotes(request.getNotes());
            tx.setPlannedExpenseId(request.getPlannedExpenseId());

            FinancialTransaction saved = moneyRepository.saveTransaction(tx);

            // If linked to planned expense, mark it executed
            if (request.getPlannedExpenseId() != null) {
                moneyRepository.markPlannedExpenseExecuted(request.getPlannedExpenseId(), userId, saved.getId());
            }

            // Update profile reported balance if profile exists
            Optional<FinancialProfile> profileOpt = moneyRepository.findProfileByUserId(userId);
            if (profileOpt.isPresent()) {
                FinancialProfile p = profileOpt.get();
                BigDecimal currentBal = p.getReportedBalance() != null ? p.getReportedBalance() : BigDecimal.ZERO;
                if (tx.getTransactionType() == TransactionType.INCOME || tx.getTransactionType() == TransactionType.REFUND) {
                    p.setReportedBalance(currentBal.add(tx.getAmount()));
                } else if (tx.getTransactionType() == TransactionType.EXPENSE) {
                    p.setReportedBalance(currentBal.subtract(tx.getAmount()).max(BigDecimal.ZERO));
                }
                moneyRepository.saveProfile(p);
            }

            return MoneyDtoMapper.toTransactionResponse(saved);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to record transaction", ex);
        }
    }

    @Override
    public TransactionResponse getTransactionById(Long userId, Long id) {
        try {
            FinancialTransaction tx = moneyRepository.findTransactionById(id, userId)
                    .orElseThrow(() -> new ResourceNotFoundException("Transaction not found or does not belong to you"));
            return MoneyDtoMapper.toTransactionResponse(tx);
        } catch (ResourceNotFoundException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve transaction", ex);
        }
    }

    @Override
    public List<TransactionResponse> getTransactions(Long userId, String type, String category, Instant fromDate, Instant toDate, int limit, int offset) {
        try {
            return moneyRepository.findTransactions(userId, type, category, fromDate, toDate, limit, offset).stream()
                    .map(MoneyDtoMapper::toTransactionResponse)
                    .collect(Collectors.toList());
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve transactions", ex);
        }
    }

    @Override
    @Transactional
    public void deleteTransaction(Long userId, Long id) {
        try {
            boolean deleted = moneyRepository.deleteTransaction(id, userId);
            if (!deleted) {
                throw new ResourceNotFoundException("Transaction not found or does not belong to you");
            }
        } catch (ResourceNotFoundException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to delete transaction", ex);
        }
    }

    @Override
    public TransactionSummaryResponse getTransactionSummary(Long userId, Instant fromDate, Instant toDate) {
        try {
            Instant start = fromDate != null ? fromDate : YearMonth.now().atDay(1).atStartOfDay(ZoneOffset.UTC).toInstant();
            Instant end = toDate != null ? toDate : Instant.now();

            BigDecimal income = moneyRepository.sumByTypeAndRange(userId, "INCOME", start, end);
            BigDecimal expense = moneyRepository.sumByTypeAndRange(userId, "EXPENSE", start, end);
            BigDecimal refund = moneyRepository.sumByTypeAndRange(userId, "REFUND", start, end);
            BigDecimal essentialExp = moneyRepository.sumExpensesByEssential(userId, true, start, end);
            BigDecimal discretionaryExp = moneyRepository.sumExpensesByEssential(userId, false, start, end);
            long count = moneyRepository.countTransactions(userId, null, null, start, end);
            Map<String, BigDecimal> byCategory = moneyRepository.getExpensesByCategoryInRange(userId, start, end);

            TransactionSummaryResponse resp = new TransactionSummaryResponse();
            resp.setTotalIncome(income);
            resp.setTotalExpenses(expense);
            resp.setTotalRefunds(refund);
            resp.setNetCashFlow(income.add(refund).subtract(expense));
            resp.setEssentialExpenses(essentialExp);
            resp.setDiscretionaryExpenses(discretionaryExp);
            resp.setTransactionCount(count);
            resp.setExpensesByCategory(byCategory);
            return resp;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to calculate transaction summary", ex);
        }
    }

    // =========================================================================
    // Spending Plan & Daily Limits
    // =========================================================================

    @Override
    public DailySpendingLimitResponse getDailySpendingLimit(Long userId) {
        try {
            LocalDate today = LocalDate.now();
            Instant startOfDay = today.atStartOfDay(ZoneOffset.UTC).toInstant();
            Instant endOfDay = today.plusDays(1).atStartOfDay(ZoneOffset.UTC).toInstant();

            FinancialProfile profile = moneyRepository.findProfileByUserId(userId).orElse(null);
            List<IncomeSource> incomeSources = moneyRepository.findIncomeSourcesByUserId(userId);
            List<FinancialCommitment> commitments = moneyRepository.findCommitmentsByUserId(userId);
            List<SavingsGoal> savingsGoals = moneyRepository.findSavingsGoalsByUserId(userId);

            LocalDate monthEnd = YearMonth.from(today).atEndOfMonth();
            List<PlannedExpense> upcomingPlanned = moneyRepository.findUpcomingPlannedExpenses(userId, today, monthEnd);
            BudgetPlan activePlan = moneyRepository.findActiveBudgetPlan(userId).orElse(null);

            BigDecimal spentToday = moneyRepository.sumExpensesToday(userId, startOfDay, endOfDay);

            Instant periodStart = activePlan != null
                    ? activePlan.getStartDate().atStartOfDay(ZoneOffset.UTC).toInstant()
                    : YearMonth.from(today).atDay(1).atStartOfDay(ZoneOffset.UTC).toInstant();
            Instant periodEnd = activePlan != null
                    ? activePlan.getEndDate().plusDays(1).atStartOfDay(ZoneOffset.UTC).toInstant()
                    : monthEnd.plusDays(1).atStartOfDay(ZoneOffset.UTC).toInstant();

            BigDecimal spentInPeriod = moneyRepository.sumByTypeAndRange(userId, "EXPENSE", periodStart, periodEnd);

            return calculationService.calculateDailySpendingLimit(
                    profile,
                    incomeSources,
                    commitments,
                    savingsGoals,
                    upcomingPlanned,
                    activePlan,
                    spentToday,
                    spentInPeriod,
                    today
            );
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to calculate daily spending limit", ex);
        }
    }

    @Override
    public SpendingBreakdownResponse getSpendingBreakdown(Long userId) {
        try {
            LocalDate today = LocalDate.now();
            Instant startOfMonth = YearMonth.from(today).atDay(1).atStartOfDay(ZoneOffset.UTC).toInstant();
            Instant endOfMonth = YearMonth.from(today).atEndOfMonth().plusDays(1).atStartOfDay(ZoneOffset.UTC).toInstant();

            BigDecimal income = moneyRepository.sumByTypeAndRange(userId, "INCOME", startOfMonth, endOfMonth);
            BigDecimal expenses = moneyRepository.sumByTypeAndRange(userId, "EXPENSE", startOfMonth, endOfMonth);
            List<FinancialCommitment> commitments = moneyRepository.findCommitmentsByUserId(userId);
            List<SavingsGoal> savings = moneyRepository.findSavingsGoalsByUserId(userId);
            List<PlannedExpense> planned = moneyRepository.findUpcomingPlannedExpenses(userId, today, YearMonth.from(today).atEndOfMonth());

            BigDecimal totalCommitments = commitments.stream().map(FinancialCommitment::getAmount).reduce(BigDecimal.ZERO, BigDecimal::add);
            BigDecimal totalSavings = savings.stream().map(SavingsGoal::getMonthlyContribution).reduce(BigDecimal.ZERO, BigDecimal::add);
            BigDecimal totalPlanned = planned.stream().map(PlannedExpense::getAmount).reduce(BigDecimal.ZERO, BigDecimal::add);

            Map<String, BigDecimal> catExpenses = moneyRepository.getExpensesByCategoryInRange(userId, startOfMonth, endOfMonth);
            Map<String, BigDecimal> commitmentsByType = commitments.stream()
                    .collect(Collectors.groupingBy(
                            c -> c.getCommitmentType() != null ? c.getCommitmentType().name() : "OTHER",
                            Collectors.reducing(BigDecimal.ZERO, FinancialCommitment::getAmount, BigDecimal::add)
                    ));

            BigDecimal unallocated = income.subtract(totalCommitments).subtract(totalSavings).subtract(totalPlanned).max(BigDecimal.ZERO);

            SpendingBreakdownResponse resp = new SpendingBreakdownResponse();
            resp.setTotalIncomeMonth(income);
            resp.setTotalExpensesMonth(expenses);
            resp.setTotalCommitmentsMonth(totalCommitments);
            resp.setTotalSavingsMonth(totalSavings);
            resp.setPlannedExpensesMonth(totalPlanned);
            resp.setUnallocatedDiscretionary(unallocated);
            resp.setBreakdownByCategory(catExpenses);
            resp.setCommitmentsByType(commitmentsByType);
            return resp;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to calculate spending breakdown", ex);
        }
    }

    @Override
    public BudgetPressureResponse getBudgetPressure(Long userId) {
        try {
            LocalDate today = LocalDate.now();
            FinancialProfile profile = moneyRepository.findProfileByUserId(userId).orElse(null);
            List<FinancialCommitment> commitments = moneyRepository.findCommitmentsByUserId(userId);
            List<PlannedExpense> planned = moneyRepository.findUpcomingPlannedExpenses(userId, today, YearMonth.from(today).atEndOfMonth());
            BudgetPlan activePlan = moneyRepository.findActiveBudgetPlan(userId).orElse(null);

            Instant startOfMonth = YearMonth.from(today).atDay(1).atStartOfDay(ZoneOffset.UTC).toInstant();
            BigDecimal actualExpenses = moneyRepository.sumByTypeAndRange(userId, "EXPENSE", startOfMonth, Instant.now());

            return calculationService.calculateBudgetPressure(profile, commitments, planned, activePlan, actualExpenses, today);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to evaluate budget pressure", ex);
        }
    }

    // =========================================================================
    // Budget Plans
    // =========================================================================

    @Override
    @Transactional
    public BudgetPlanResponse createBudgetPlan(Long userId, BudgetPlanRequest request) {
        if (request.getStartDate().isAfter(request.getEndDate())) {
            throw new BusinessException(ApiResponse.ErrorCode.INVALID_DATE_RANGE, "Budget plan start date cannot be after end date");
        }

        try {
            BudgetPlan plan = new BudgetPlan();
            plan.setUserId(userId);
            plan.setPeriodType(request.getPeriodType());
            plan.setStartDate(request.getStartDate());
            plan.setEndDate(request.getEndDate());
            plan.setTotalBudget(request.getTotalBudget());
            plan.setCarryForwardRule(request.getCarryForwardRule() != null ? request.getCarryForwardRule() : CarryForwardRule.UNSPENT_ONLY);
            plan.setNotes(request.getNotes());
            plan.setActive(true);

            if (request.getCategoryLimits() != null) {
                List<BudgetCategoryLimit> limits = request.getCategoryLimits().stream()
                        .map(dto -> new BudgetCategoryLimit(dto.getCategoryName(), dto.getAllocatedAmount(), dto.getEssential() != null ? dto.getEssential() : false))
                        .collect(Collectors.toList());
                plan.setCategoryLimits(limits);
            }

            BudgetPlan saved = moneyRepository.saveBudgetPlan(plan);
            return getBudgetPlanDetails(saved, userId);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to create budget plan", ex);
        }
    }

    @Override
    public BudgetPlanResponse getActiveBudgetPlan(Long userId) {
        try {
            BudgetPlan plan = moneyRepository.findActiveBudgetPlan(userId)
                    .orElseThrow(() -> new ResourceNotFoundException("No active budget plan found. Please create one."));
            return getBudgetPlanDetails(plan, userId);
        } catch (ResourceNotFoundException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve active budget plan", ex);
        }
    }

    @Override
    public List<BudgetPlanResponse> getBudgetPlans(Long userId) {
        try {
            return moneyRepository.findBudgetPlansByUserId(userId).stream()
                    .map(p -> getBudgetPlanDetails(p, userId))
                    .collect(Collectors.toList());
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve budget plans", ex);
        }
    }

    @Override
    public BudgetPlanResponse getBudgetPlanById(Long userId, Long id) {
        try {
            BudgetPlan plan = moneyRepository.findBudgetPlanById(id, userId)
                    .orElseThrow(() -> new ResourceNotFoundException("Budget plan not found or does not belong to you"));
            return getBudgetPlanDetails(plan, userId);
        } catch (ResourceNotFoundException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve budget plan", ex);
        }
    }

    @Override
    @Transactional
    public void deleteBudgetPlan(Long userId, Long id) {
        try {
            boolean deleted = moneyRepository.deleteBudgetPlan(id, userId);
            if (!deleted) {
                throw new ResourceNotFoundException("Budget plan not found or does not belong to you");
            }
        } catch (ResourceNotFoundException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to delete budget plan", ex);
        }
    }

    private BudgetPlanResponse getBudgetPlanDetails(BudgetPlan plan, Long userId) {
        BudgetPlanResponse resp = MoneyDtoMapper.toBudgetPlanResponse(plan);

        Instant start = plan.getStartDate().atStartOfDay(ZoneOffset.UTC).toInstant();
        Instant end = plan.getEndDate().plusDays(1).atStartOfDay(ZoneOffset.UTC).toInstant();
        BigDecimal actualExpenses = moneyRepository.sumByTypeAndRange(userId, "EXPENSE", start, end);

        BigDecimal effectiveBudget = plan.getTotalBudget().add(plan.getCarriedForwardAmount() != null ? plan.getCarriedForwardAmount() : BigDecimal.ZERO);
        BigDecimal remaining = effectiveBudget.subtract(actualExpenses).max(BigDecimal.ZERO);

        LocalDate today = LocalDate.now();
        long daysRemaining = Math.max(1, java.time.temporal.ChronoUnit.DAYS.between(today, plan.getEndDate()) + 1);
        BigDecimal dailyLimit = remaining.divide(BigDecimal.valueOf(daysRemaining), 2, RoundingMode.HALF_UP);

        BigDecimal utilization = BigDecimal.ZERO;
        if (effectiveBudget.compareTo(BigDecimal.ZERO) > 0) {
            utilization = actualExpenses.multiply(BigDecimal.valueOf(100)).divide(effectiveBudget, 2, RoundingMode.HALF_UP);
        }

        resp.setActualExpenses(actualExpenses);
        resp.setRemainingBudget(remaining);
        resp.setDailyRecommendedSpending(dailyLimit);
        resp.setPeriodUtilizationPercent(utilization);
        return resp;
    }

    // =========================================================================
    // Planned Expenses
    // =========================================================================

    @Override
    public List<PlannedExpenseResponse> getPlannedExpenses(Long userId) {
        try {
            return moneyRepository.findPlannedExpensesByUserId(userId).stream()
                    .map(MoneyDtoMapper::toPlannedExpenseResponse)
                    .collect(Collectors.toList());
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve planned expenses", ex);
        }
    }

    @Override
    @Transactional
    public PlannedExpenseResponse createPlannedExpense(Long userId, PlannedExpenseRequest request) {
        try {
            PlannedExpense expense = new PlannedExpense();
            expense.setUserId(userId);
            expense.setTitle(request.getTitle().trim());
            expense.setAmount(request.getAmount());
            expense.setPlannedDate(request.getPlannedDate());
            expense.setCategoryName(request.getCategoryName());
            expense.setEssential(request.getEssential() != null ? request.getEssential() : false);
            expense.setNotes(request.getNotes());

            PlannedExpense saved = moneyRepository.savePlannedExpense(expense);
            return MoneyDtoMapper.toPlannedExpenseResponse(saved);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to schedule planned expense", ex);
        }
    }

    @Override
    @Transactional
    public void deletePlannedExpense(Long userId, Long id) {
        try {
            boolean deleted = moneyRepository.deletePlannedExpense(id, userId);
            if (!deleted) {
                throw new ResourceNotFoundException("Planned expense not found or does not belong to you");
            }
        } catch (ResourceNotFoundException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to delete planned expense", ex);
        }
    }

    @Override
    @Transactional
    public TransactionResponse executePlannedExpense(Long userId, Long id) {
        try {
            PlannedExpense expense = moneyRepository.findPlannedExpenseById(id, userId)
                    .orElseThrow(() -> new ResourceNotFoundException("Planned expense not found or does not belong to you"));

            if (expense.isExecuted()) {
                throw new BusinessException(ApiResponse.ErrorCode.BAD_REQUEST, "Planned expense has already been executed");
            }

            TransactionCreateRequest txRequest = new TransactionCreateRequest();
            txRequest.setTransactionType(TransactionType.EXPENSE);
            txRequest.setCategoryName(expense.getCategoryName() != null ? expense.getCategoryName() : "General Expense");
            txRequest.setAmount(expense.getAmount());
            txRequest.setEssential(expense.isEssential());
            txRequest.setNotes("Executed from planned expense: " + expense.getTitle());
            txRequest.setPlannedExpenseId(expense.getId());

            return createTransaction(userId, txRequest);
        } catch (ResourceNotFoundException | BusinessException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to execute planned expense", ex);
        }
    }

    // =========================================================================
    // Recurring Schedules
    // =========================================================================

    @Override
    public List<RecurringScheduleResponse> getRecurringSchedules(Long userId) {
        try {
            return moneyRepository.findRecurringSchedulesByUserId(userId).stream()
                    .map(s -> {
                        RecurringScheduleResponse resp = MoneyDtoMapper.toScheduleResponse(s);
                        LocalDate next = calculationService.computeNextOccurrenceDate(
                                s.getStartDate(),
                                s.getLastGeneratedDate(),
                                s.getFrequency() != null ? s.getFrequency().name() : "MONTHLY",
                                s.getDayOfMonth(),
                                s.getDayOfWeek(),
                                LocalDate.now()
                        );
                        resp.setNextOccurrenceDate(next);
                        return resp;
                    })
                    .collect(Collectors.toList());
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve recurring schedules", ex);
        }
    }

    @Override
    @Transactional
    public RecurringScheduleResponse createRecurringSchedule(Long userId, RecurringScheduleRequest request) {
        try {
            RecurringSchedule schedule = new RecurringSchedule();
            schedule.setUserId(userId);
            schedule.setTitle(request.getTitle().trim());
            schedule.setTransactionType(request.getTransactionType());
            schedule.setCategoryName(request.getCategoryName());
            schedule.setAmount(request.getAmount());
            schedule.setFrequency(request.getFrequency());
            schedule.setStartDate(request.getStartDate());
            schedule.setEndDate(request.getEndDate());
            schedule.setDayOfMonth(request.getDayOfMonth());
            schedule.setDayOfWeek(request.getDayOfWeek());
            schedule.setEssential(request.getEssential() != null ? request.getEssential() : false);
            schedule.setPaymentMethod(request.getPaymentMethod() != null ? request.getPaymentMethod() : PaymentMethod.UPI);
            schedule.setActive(true);

            RecurringSchedule saved = moneyRepository.saveRecurringSchedule(schedule);

            // Pre-generate initial occurrence
            LocalDate nextDate = calculationService.computeNextOccurrenceDate(
                    saved.getStartDate(),
                    null,
                    saved.getFrequency() != null ? saved.getFrequency().name() : "MONTHLY",
                    saved.getDayOfMonth(),
                    saved.getDayOfWeek(),
                    LocalDate.now()
            );

            RecurringOccurrence occ = new RecurringOccurrence();
            occ.setScheduleId(saved.getId());
            occ.setUserId(userId);
            occ.setScheduledDate(nextDate);
            occ.setAmount(saved.getAmount());
            occ.setStatus(OccurrenceStatus.PENDING);
            moneyRepository.saveOccurrence(occ);
            moneyRepository.updateScheduleLastGenerated(saved.getId(), nextDate);

            RecurringScheduleResponse resp = MoneyDtoMapper.toScheduleResponse(saved);
            resp.setNextOccurrenceDate(nextDate);
            return resp;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to create recurring schedule", ex);
        }
    }

    @Override
    @Transactional
    public void deleteRecurringSchedule(Long userId, Long id) {
        try {
            boolean deleted = moneyRepository.deleteRecurringSchedule(id, userId);
            if (!deleted) {
                throw new ResourceNotFoundException("Recurring schedule not found or does not belong to you");
            }
        } catch (ResourceNotFoundException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to delete recurring schedule", ex);
        }
    }

    @Override
    public List<RecurringOccurrenceResponse> getUpcomingOccurrences(Long userId) {
        try {
            LocalDate today = LocalDate.now();
            LocalDate horizon = today.plusMonths(1);
            List<RecurringOccurrence> list = moneyRepository.findOccurrencesByUserAndRange(userId, today, horizon);

            Map<Long, String> titles = moneyRepository.findRecurringSchedulesByUserId(userId).stream()
                    .collect(Collectors.toMap(RecurringSchedule::getId, RecurringSchedule::getTitle));

            return list.stream()
                    .map(o -> MoneyDtoMapper.toOccurrenceResponse(o, titles.getOrDefault(o.getScheduleId(), "Recurring Schedule")))
                    .collect(Collectors.toList());
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve upcoming occurrences", ex);
        }
    }

    @Override
    @Transactional
    public TransactionResponse processOccurrence(Long userId, Long occurrenceId) {
        try {
            RecurringOccurrence occ = moneyRepository.findOccurrenceById(occurrenceId, userId)
                    .orElseThrow(() -> new ResourceNotFoundException("Recurring occurrence not found or does not belong to you"));

            if (occ.getStatus() == OccurrenceStatus.PROCESSED) {
                throw new BusinessException(ApiResponse.ErrorCode.BAD_REQUEST, "Occurrence has already been processed");
            }

            RecurringSchedule schedule = moneyRepository.findRecurringScheduleById(occ.getScheduleId(), userId)
                    .orElseThrow(() -> new ResourceNotFoundException("Parent recurring schedule not found"));

            TransactionCreateRequest txRequest = new TransactionCreateRequest();
            txRequest.setTransactionType(schedule.getTransactionType());
            txRequest.setCategoryName(schedule.getCategoryName() != null ? schedule.getCategoryName() : "Recurring");
            txRequest.setAmount(occ.getAmount());
            txRequest.setEssential(schedule.isEssential());
            txRequest.setPaymentMethod(schedule.getPaymentMethod());
            txRequest.setNotes("Processed occurrence of " + schedule.getTitle() + " on " + occ.getScheduledDate());

            TransactionResponse tx = createTransaction(userId, txRequest);
            moneyRepository.markOccurrenceProcessed(occurrenceId, userId, tx.getId());

            // Generate the subsequent occurrence
            LocalDate nextDate = calculationService.computeNextOccurrenceDate(
                    schedule.getStartDate(),
                    occ.getScheduledDate(),
                    schedule.getFrequency() != null ? schedule.getFrequency().name() : "MONTHLY",
                    schedule.getDayOfMonth(),
                    schedule.getDayOfWeek(),
                    LocalDate.now()
            );

            if (schedule.getEndDate() == null || !nextDate.isAfter(schedule.getEndDate())) {
                RecurringOccurrence nextOcc = new RecurringOccurrence();
                nextOcc.setScheduleId(schedule.getId());
                nextOcc.setUserId(userId);
                nextOcc.setScheduledDate(nextDate);
                nextOcc.setAmount(schedule.getAmount());
                nextOcc.setStatus(OccurrenceStatus.PENDING);
                moneyRepository.saveOccurrence(nextOcc);
                moneyRepository.updateScheduleLastGenerated(schedule.getId(), nextDate);
            }

            return tx;
        } catch (ResourceNotFoundException | BusinessException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to process recurring occurrence", ex);
        }
    }
}
