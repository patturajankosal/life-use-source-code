package com.lifeuse.money.service;

import com.lifeuse.common.constants.CommonConstants;
import com.lifeuse.common.utility.DateUtils;
import com.lifeuse.common.utility.MoneyUtils;
import com.lifeuse.money.models.dto.*;
import com.lifeuse.money.models.entity.*;
import com.lifeuse.money.models.enums.PressureLevel;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@Service
public class MoneyCalculationService implements IMoneyCalculationService {

    private static final RoundingMode ROUNDING = CommonConstants.DEFAULT_ROUNDING_MODE;
    private static final int SCALE = CommonConstants.DEFAULT_MONEY_SCALE;

    @Override
    public DailySpendingLimitResponse calculateDailySpendingLimit(
            FinancialProfile profile,
            List<IncomeSource> incomeSources,
            List<FinancialCommitment> commitments,
            List<SavingsGoal> savingsGoals,
            List<PlannedExpense> upcomingPlannedExpenses,
            BudgetPlan activeBudgetPlan,
            BigDecimal spentToday,
            BigDecimal spentInPeriod,
            LocalDate calculationDate
    ) {
        DailySpendingLimitResponse resp = new DailySpendingLimitResponse();
        LocalDate today = calculationDate != null ? calculationDate : LocalDate.now();

        // 1. Initial reported funds and reserves
        BigDecimal reportedFunds = profile != null ? MoneyUtils.scale(profile.getReportedBalance()) : MoneyUtils.scale(BigDecimal.ZERO);
        BigDecimal emergencyReserve = profile != null ? MoneyUtils.scale(profile.getEmergencyReserve()) : MoneyUtils.scale(BigDecimal.ZERO);
        BigDecimal minimumCashReserve = profile != null ? MoneyUtils.scale(profile.getMinimumCashReserve()) : MoneyUtils.scale(BigDecimal.ZERO);
        BigDecimal totalReserves = MoneyUtils.safeAdd(emergencyReserve, minimumCashReserve);

        // 2. Sum commitments for the period
        BigDecimal reservedCommitments = MoneyUtils.scale(BigDecimal.ZERO);
        if (commitments != null) {
            for (FinancialCommitment c : commitments) {
                if (c.isActive() && c.getAmount() != null) {
                    reservedCommitments = MoneyUtils.safeAdd(reservedCommitments, c.getAmount());
                }
            }
        }

        // 3. Sum monthly savings contributions
        BigDecimal reservedSavings = MoneyUtils.scale(BigDecimal.ZERO);
        if (savingsGoals != null) {
            for (SavingsGoal g : savingsGoals) {
                if (g.isActive() && g.getMonthlyContribution() != null) {
                    reservedSavings = MoneyUtils.safeAdd(reservedSavings, g.getMonthlyContribution());
                }
            }
        }

        // 4. Sum upcoming planned expenses
        BigDecimal plannedExpensesAhead = MoneyUtils.scale(BigDecimal.ZERO);
        if (upcomingPlannedExpenses != null) {
            for (PlannedExpense pe : upcomingPlannedExpenses) {
                if (!pe.isExecuted() && pe.getAmount() != null) {
                    plannedExpensesAhead = MoneyUtils.safeAdd(plannedExpensesAhead, pe.getAmount());
                }
            }
        }

        // 5. Determine planning period horizon and remaining days
        LocalDate periodEnd;
        BigDecimal allocatedPeriodBudget;
        if (activeBudgetPlan != null && activeBudgetPlan.getEndDate() != null) {
            periodEnd = activeBudgetPlan.getEndDate();
            allocatedPeriodBudget = MoneyUtils.safeAdd(activeBudgetPlan.getTotalBudget(), activeBudgetPlan.getCarriedForwardAmount());
        } else {
            // Default to end of current month
            periodEnd = DateUtils.clampToMonthEnd(YearMonth.from(today), 31);
            allocatedPeriodBudget = reportedFunds;
        }

        long daysRemaining = DateUtils.daysBetweenInclusive(today, periodEnd);
        if (daysRemaining < 1) daysRemaining = 1;

        // 6. Calculate available and discretionary funds
        BigDecimal availableFunds = reportedFunds;
        // Total obligations to safeguard
        BigDecimal totalProtected = MoneyUtils.safeAdd(
                MoneyUtils.safeAdd(reservedCommitments, reservedSavings),
                MoneyUtils.safeAdd(totalReserves, plannedExpensesAhead)
        );
        BigDecimal discretionaryBudget = MoneyUtils.safeSubtract(availableFunds, totalProtected);

        // Deduct expenses already incurred in this period if using reported balance baseline
        if (activeBudgetPlan != null) {
            BigDecimal remainingPeriodBudget = MoneyUtils.safeSubtract(allocatedPeriodBudget, spentInPeriod);
            discretionaryBudget = MoneyUtils.safeSubtract(remainingPeriodBudget, totalProtected);
        }

        // Warnings and Insights collection
        List<String> warnings = new ArrayList<>();
        List<String> insights = new ArrayList<>();

        if (profile == null) {
            warnings.add("Financial profile is not set up. Using conservative default estimates.");
        }
        if (commitments == null || commitments.isEmpty()) {
            insights.add("No recurring commitments (EMI, Rent, Bills) configured. Ensure all regular dues are added.");
        }
        if (savingsGoals == null || savingsGoals.isEmpty()) {
            insights.add("No savings goals active. Consider designating a portion of your funds for savings.");
        }

        BigDecimal recommendedDailyLimit;
        if (!MoneyUtils.isPositive(discretionaryBudget)) {
            recommendedDailyLimit = MoneyUtils.scale(BigDecimal.ZERO);
            warnings.add("Available discretionary funds are exhausted or in deficit. Recommended daily spending is paused to preserve core commitments and reserves.");
        } else {
            recommendedDailyLimit = MoneyUtils.safeDivide(discretionaryBudget, BigDecimal.valueOf(daysRemaining));
        }

        BigDecimal todaySpent = MoneyUtils.scale(spentToday);
        BigDecimal remainingTodayAllowance = MoneyUtils.scale(recommendedDailyLimit.subtract(todaySpent).max(BigDecimal.ZERO));

        // Period utilization
        BigDecimal budgetUtilization = MoneyUtils.percentage(spentInPeriod, allocatedPeriodBudget);

        // Concise explanation
        String explanation = String.format(
                "Calculated based on available funds ₹%s minus reserves ₹%s (commitments: ₹%s, savings: ₹%s, planned expenses: ₹%s, cash reserve: ₹%s) distributed across %d remaining day(s) until %s.",
                availableFunds.toPlainString(),
                totalProtected.toPlainString(),
                reservedCommitments.toPlainString(),
                reservedSavings.toPlainString(),
                plannedExpensesAhead.toPlainString(),
                totalReserves.toPlainString(),
                daysRemaining,
                periodEnd
        );

        resp.setRecommendedDailyLimit(recommendedDailyLimit);
        resp.setSpentToday(todaySpent);
        resp.setRemainingTodayAllowance(remainingTodayAllowance);
        resp.setReportedFunds(reportedFunds);
        resp.setCalculatedAvailableFunds(availableFunds);
        resp.setReservedForCommitments(reservedCommitments);
        resp.setReservedForSavings(reservedSavings);
        resp.setPlannedExpensesAhead(plannedExpensesAhead);
        resp.setEmergencyReserve(totalReserves);
        resp.setRemainingDiscretionaryBudget(discretionaryBudget.max(BigDecimal.ZERO).setScale(SCALE, ROUNDING));
        resp.setRemainingDaysInPeriod((int) daysRemaining);
        resp.setBudgetUtilizationPercent(budgetUtilization);
        resp.setExplanation(explanation);
        resp.setWarnings(warnings);
        resp.setActionableInsights(insights);

        return resp;
    }

    @Override
    public BudgetPressureResponse calculateBudgetPressure(
            FinancialProfile profile,
            List<FinancialCommitment> commitments,
            List<PlannedExpense> plannedExpenses,
            BudgetPlan activeBudgetPlan,
            BigDecimal actualExpensesInPeriod,
            LocalDate currentDate
    ) {
        BudgetPressureResponse resp = new BudgetPressureResponse();
        LocalDate today = currentDate != null ? currentDate : LocalDate.now();

        BigDecimal reportedFunds = profile != null ? MoneyUtils.scale(profile.getReportedBalance()) : MoneyUtils.scale(BigDecimal.ZERO);

        BigDecimal upcomingCommitments = MoneyUtils.scale(BigDecimal.ZERO);
        if (commitments != null) {
            for (FinancialCommitment c : commitments) {
                if (c.isActive() && c.getAmount() != null) {
                    upcomingCommitments = MoneyUtils.safeAdd(upcomingCommitments, c.getAmount());
                }
            }
        }

        BigDecimal upcomingPlanned = MoneyUtils.scale(BigDecimal.ZERO);
        if (plannedExpenses != null) {
            for (PlannedExpense p : plannedExpenses) {
                if (!p.isExecuted() && p.getAmount() != null) {
                    upcomingPlanned = MoneyUtils.safeAdd(upcomingPlanned, p.getAmount());
                }
            }
        }

        BigDecimal totalObligations = MoneyUtils.safeAdd(upcomingCommitments, upcomingPlanned);
        BigDecimal projectedEndBalance = MoneyUtils.safeSubtract(
                MoneyUtils.safeSubtract(reportedFunds, totalObligations),
                actualExpensesInPeriod
        );

        // Pressure score calculation: obligations / (available + 1) * 100
        BigDecimal divisor = MoneyUtils.isPositive(reportedFunds) ? reportedFunds : BigDecimal.ONE;
        BigDecimal pressureRatio = MoneyUtils.safeDivide(totalObligations.multiply(BigDecimal.valueOf(100)), divisor);

        PressureLevel level;
        List<String> factors = new ArrayList<>();
        List<String> recs = new ArrayList<>();

        if (reportedFunds.compareTo(BigDecimal.ZERO) <= 0 || projectedEndBalance.compareTo(BigDecimal.ZERO) < 0) {
            level = PressureLevel.CRITICAL;
            factors.add("Projected end balance is negative (deficit of ₹" + projectedEndBalance.abs().toPlainString() + ").");
            recs.add("Prioritize mandatory debt and utility bills; defer discretionary expenses and non-essential planned purchases.");
        } else if (pressureRatio.compareTo(BigDecimal.valueOf(80)) >= 0) {
            level = PressureLevel.HIGH;
            factors.add("Upcoming obligations consume over 80% of current available funds.");
            recs.add("Exercise strict spending control over the next few days to safeguard pending commitments.");
        } else if (pressureRatio.compareTo(BigDecimal.valueOf(50)) >= 0) {
            level = PressureLevel.MODERATE;
            factors.add("Moderate commitment pressure scheduled in the current cycle.");
            recs.add("Maintain regular budget limits; plan discretionary purchases around commitment due dates.");
        } else {
            level = PressureLevel.HEALTHY;
            factors.add("Obligations are well within available funds.");
            recs.add("Your current budget pace is healthy and sustainable.");
        }

        resp.setPressureLevel(level);
        resp.setPressureScore(pressureRatio.min(BigDecimal.valueOf(100)));
        resp.setUpcomingCommitmentsTotal(upcomingCommitments);
        resp.setUpcomingPlannedExpensesTotal(upcomingPlanned);
        resp.setProjectedBalanceAtPeriodEnd(projectedEndBalance.setScale(SCALE, ROUNDING));
        resp.setSummaryText(String.format("Current financial pressure is %s with upcoming obligations totaling ₹%s against funds of ₹%s.",
                level, totalObligations.toPlainString(), reportedFunds.toPlainString()));
        resp.setPressureFactors(factors);
        resp.setActionableRecommendations(recs);

        return resp;
    }

    @Override
    public SpecialDayImpactResponse calculateSpecialDayImpact(
            LocalDate specialDate,
            BigDecimal extraAmount,
            FinancialProfile profile,
            BudgetPlan activeBudgetPlan,
            BigDecimal currentDiscretionaryRemaining,
            LocalDate currentDate
    ) {
        SpecialDayImpactResponse resp = new SpecialDayImpactResponse();
        LocalDate today = currentDate != null ? currentDate : LocalDate.now();

        BigDecimal extra = MoneyUtils.scale(extraAmount);
        BigDecimal pool = MoneyUtils.scale(currentDiscretionaryRemaining);

        LocalDate periodEnd = (activeBudgetPlan != null && activeBudgetPlan.getEndDate() != null)
                ? activeBudgetPlan.getEndDate()
                : DateUtils.clampToMonthEnd(YearMonth.from(today), 31);

        long totalDays = DateUtils.daysBetweenInclusive(today, periodEnd);
        if (totalDays < 1) totalDays = 1;

        BigDecimal regularDailyBefore = totalDays > 0 ? MoneyUtils.safeDivide(pool, BigDecimal.valueOf(totalDays)) : MoneyUtils.scale(BigDecimal.ZERO);

        // Discretionary after special event
        BigDecimal poolAfter = pool.subtract(extra).max(BigDecimal.ZERO);
        long otherDays = Math.max(1, totalDays - 1);
        BigDecimal adjustedDailyOther = MoneyUtils.safeDivide(poolAfter, BigDecimal.valueOf(otherDays));

        BigDecimal specialDayAllowance = MoneyUtils.safeAdd(adjustedDailyOther, extra);

        resp.setSpecialDate(specialDate);
        resp.setSpecialDayExtraAmount(extra);
        resp.setRegularDailyLimitBefore(regularDailyBefore);
        resp.setAdjustedDailyLimitOtherDays(adjustedDailyOther);
        resp.setSpecialDayTotalAllowance(specialDayAllowance);
        resp.setExplanation(String.format(
                "Allocating ₹%s on %s adjusts the daily spending allowance from ₹%s to ₹%s across the other %d day(s) of this period.",
                extra.toPlainString(), specialDate, regularDailyBefore.toPlainString(), adjustedDailyOther.toPlainString(), otherDays
        ));

        List<String> options = new ArrayList<>();
        options.add("Option 1 (Equal Absorption): Absorb ₹" + extra.toPlainString() + " uniformly at ₹" + regularDailyBefore.subtract(adjustedDailyOther).toPlainString() + "/day across all " + otherDays + " other days.");
        options.add("Option 2 (Weekend Offset): Keep weekday limits untouched and deduct ₹" + extra.toPlainString() + " specifically from the upcoming weekend allowance.");
        options.add("Option 3 (Savings Offset): Fund the ₹" + extra.toPlainString() + " expense by temporarily reducing this month's discretionary savings allocation.");
        resp.setAlternativeOptions(options);

        return resp;
    }

    @Override
    public LocalDate computeNextOccurrenceDate(
            LocalDate startDate,
            LocalDate lastGeneratedDate,
            String frequency,
            Integer dayOfMonth,
            String dayOfWeek,
            LocalDate currentDate
    ) {
        LocalDate base = lastGeneratedDate != null ? lastGeneratedDate : startDate.minusDays(1);
        if (base.isBefore(startDate.minusDays(1))) {
            base = startDate.minusDays(1);
        }

        if (frequency == null) frequency = "MONTHLY";

        switch (frequency.toUpperCase()) {
            case "DAILY":
                return base.plusDays(1);

            case "WEEKLY":
                if (dayOfWeek != null && !dayOfWeek.isBlank()) {
                    DayOfWeek targetDow = DayOfWeek.valueOf(dayOfWeek.toUpperCase());
                    LocalDate next = base.plusDays(1);
                    while (next.getDayOfWeek() != targetDow) {
                        next = next.plusDays(1);
                    }
                    return next;
                }
                return base.plusWeeks(1);

            case "BI_WEEKLY":
                return base.plusWeeks(2);

            case "MONTHLY": {
                LocalDate targetMonth = base.plusMonths(1);
                int dom = dayOfMonth != null ? dayOfMonth : startDate.getDayOfMonth();
                return DateUtils.clampedDate(targetMonth.getYear(), targetMonth.getMonthValue(), dom);
            }

            case "QUARTERLY": {
                LocalDate targetMonth = base.plusMonths(3);
                int dom = dayOfMonth != null ? dayOfMonth : startDate.getDayOfMonth();
                return DateUtils.clampedDate(targetMonth.getYear(), targetMonth.getMonthValue(), dom);
            }

            case "YEARLY": {
                LocalDate targetYear = base.plusYears(1);
                int dom = dayOfMonth != null ? dayOfMonth : startDate.getDayOfMonth();
                return DateUtils.clampedDate(targetYear.getYear(), targetYear.getMonthValue(), dom);
            }

            default:
                return base.plusMonths(1);
        }
    }
}
