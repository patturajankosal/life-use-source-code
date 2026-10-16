package com.lifeuse.money.service;

import com.lifeuse.money.models.dto.*;
import com.lifeuse.money.models.entity.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface IMoneyCalculationService {

    DailySpendingLimitResponse calculateDailySpendingLimit(
            FinancialProfile profile,
            List<IncomeSource> incomeSources,
            List<FinancialCommitment> commitments,
            List<SavingsGoal> savingsGoals,
            List<PlannedExpense> upcomingPlannedExpenses,
            BudgetPlan activeBudgetPlan,
            BigDecimal spentToday,
            BigDecimal spentInPeriod,
            LocalDate calculationDate
    );

    BudgetPressureResponse calculateBudgetPressure(
            FinancialProfile profile,
            List<FinancialCommitment> commitments,
            List<PlannedExpense> plannedExpenses,
            BudgetPlan activeBudgetPlan,
            BigDecimal actualExpensesInPeriod,
            LocalDate currentDate
    );

    SpecialDayImpactResponse calculateSpecialDayImpact(
            LocalDate specialDate,
            BigDecimal extraAmount,
            FinancialProfile profile,
            BudgetPlan activeBudgetPlan,
            BigDecimal currentDiscretionaryRemaining,
            LocalDate currentDate
    );

    LocalDate computeNextOccurrenceDate(
            LocalDate startDate,
            LocalDate lastGeneratedDate,
            String frequency,
            Integer dayOfMonth,
            String dayOfWeek,
            LocalDate currentDate
    );
}
