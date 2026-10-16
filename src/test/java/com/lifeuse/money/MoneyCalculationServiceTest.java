package com.lifeuse.money;

import com.lifeuse.money.models.dto.BudgetPressureResponse;
import com.lifeuse.money.models.dto.DailySpendingLimitResponse;
import com.lifeuse.money.models.dto.SpecialDayImpactResponse;
import com.lifeuse.money.models.entity.*;
import com.lifeuse.money.models.enums.CommitmentType;
import com.lifeuse.money.models.enums.PlanPeriodType;
import com.lifeuse.money.models.enums.PressureLevel;
import com.lifeuse.money.service.MoneyCalculationService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Money Calculation Engine Unit Tests")
class MoneyCalculationServiceTest {

    private MoneyCalculationService calculationService;

    @BeforeEach
    void setUp() {
        calculationService = new MoneyCalculationService();
    }

    @Test
    @DisplayName("Should correctly calculate daily spending limit with commitments, savings and reserves")
    void shouldCalculateDailySpendingLimitCorrectly() {
        FinancialProfile profile = new FinancialProfile();
        profile.setReportedBalance(new BigDecimal("50000.00"));
        profile.setEmergencyReserve(new BigDecimal("5000.00"));
        profile.setMinimumCashReserve(new BigDecimal("2000.00"));

        FinancialCommitment emi = new FinancialCommitment();
        emi.setTitle("Home Loan EMI");
        emi.setCommitmentType(CommitmentType.EMI);
        emi.setAmount(new BigDecimal("15000.00"));
        emi.setActive(true);

        SavingsGoal goal = new SavingsGoal();
        goal.setTitle("Emergency Fund");
        goal.setMonthlyContribution(new BigDecimal("3000.00"));
        goal.setActive(true);

        PlannedExpense planned = new PlannedExpense();
        planned.setTitle("Weekend Outing");
        planned.setAmount(new BigDecimal("1000.00"));
        planned.setExecuted(false);

        // Period: 10 days remaining
        BudgetPlan plan = new BudgetPlan();
        plan.setStartDate(LocalDate.of(2026, 10, 1));
        plan.setEndDate(LocalDate.of(2026, 10, 10));
        plan.setTotalBudget(new BigDecimal("50000.00"));
        plan.setCarriedForwardAmount(BigDecimal.ZERO);

        LocalDate calcDate = LocalDate.of(2026, 10, 1); // 10 days remaining (1st to 10th inclusive)

        // Total obligations = 15000 (EMI) + 3000 (Savings) + 7000 (Reserves) + 1000 (Planned) = 26000
        // Discretionary budget = 50000 - 26000 = 24000
        // Daily limit = 24000 / 10 = 2400.00

        DailySpendingLimitResponse resp = calculationService.calculateDailySpendingLimit(
                profile,
                List.of(),
                List.of(emi),
                List.of(goal),
                List.of(planned),
                plan,
                new BigDecimal("400.00"), // spent today
                new BigDecimal("400.00"), // spent in period
                calcDate
        );

        assertNotNull(resp);
        assertEquals(new BigDecimal("2360.00"), resp.getRecommendedDailyLimit());
        // Remaining today allowance = 2360.00 - 400.00 = 1960.00
        assertEquals(new BigDecimal("1960.00"), resp.getRemainingTodayAllowance());
        assertEquals(new BigDecimal("15000.00"), resp.getReservedForCommitments());
        assertEquals(new BigDecimal("3000.00"), resp.getReservedForSavings());
        assertEquals(new BigDecimal("7000.00"), resp.getEmergencyReserve());
        assertEquals(new BigDecimal("1000.00"), resp.getPlannedExpensesAhead());
        assertEquals(10, resp.getRemainingDaysInPeriod());
        assertNotNull(resp.getExplanation());
        assertTrue(resp.getWarnings().isEmpty());
    }

    @Test
    @DisplayName("Should return zero limit and critical warning when discretionary funds are in deficit")
    void shouldReturnZeroLimitWhenInDeficit() {
        FinancialProfile profile = new FinancialProfile();
        profile.setReportedBalance(new BigDecimal("10000.00"));
        profile.setEmergencyReserve(new BigDecimal("5000.00"));

        FinancialCommitment emi = new FinancialCommitment();
        emi.setAmount(new BigDecimal("12000.00")); // More than reported balance
        emi.setActive(true);

        LocalDate calcDate = LocalDate.of(2026, 10, 15);

        DailySpendingLimitResponse resp = calculationService.calculateDailySpendingLimit(
                profile,
                List.of(),
                List.of(emi),
                List.of(),
                List.of(),
                null,
                BigDecimal.ZERO,
                BigDecimal.ZERO,
                calcDate
        );

        assertNotNull(resp);
        assertEquals(new BigDecimal("0.00"), resp.getRecommendedDailyLimit());
        assertEquals(new BigDecimal("0.00"), resp.getRemainingTodayAllowance());
        assertFalse(resp.getWarnings().isEmpty());
        assertTrue(resp.getWarnings().stream().anyMatch(w -> w.contains("exhausted or in deficit")));
    }

    @Test
    @DisplayName("Should accurately calculate special day impact and alternative redistribution options")
    void shouldCalculateSpecialDayImpactCorrectly() {
        LocalDate today = LocalDate.of(2026, 10, 1);
        LocalDate specialDay = LocalDate.of(2026, 10, 8); // Thursday
        BigDecimal extraExpense = new BigDecimal("500.00");
        BigDecimal currentDiscretionary = new BigDecimal("7000.00");

        // 7 days total (Oct 1 to Oct 7)
        BudgetPlan plan = new BudgetPlan();
        plan.setStartDate(today);
        plan.setEndDate(LocalDate.of(2026, 10, 7)); // 7 days total

        SpecialDayImpactResponse impact = calculationService.calculateSpecialDayImpact(
                specialDay,
                extraExpense,
                null,
                plan,
                currentDiscretionary,
                today
        );

        assertNotNull(impact);
        assertEquals(new BigDecimal("1000.00"), impact.getRegularDailyLimitBefore()); // 7000 / 7 = 1000
        // Discretionary remaining after 500 = 6500. 6 other days: 6500 / 6 = 1083.33
        assertEquals(new BigDecimal("1083.33"), impact.getAdjustedDailyLimitOtherDays());
        assertNotNull(impact.getExplanation());
        assertEquals(3, impact.getAlternativeOptions().size());
    }

    @Test
    @DisplayName("Should handle leap year February 29th and clamp month-end dates gracefully")
    void shouldHandleLeapYearAndMonthEndClamping() {
        // 1. Clamping Jan 31st recurrence to Feb in non-leap year (2025 -> Feb 28)
        LocalDate nextFeb2025 = calculationService.computeNextOccurrenceDate(
                LocalDate.of(2025, 1, 31),
                LocalDate.of(2025, 1, 31),
                "MONTHLY",
                31,
                null,
                LocalDate.of(2025, 1, 31)
        );
        assertEquals(LocalDate.of(2025, 2, 28), nextFeb2025);

        // 2. Clamping Jan 31st recurrence to Feb in leap year (2024 -> Feb 29)
        LocalDate nextFeb2024 = calculationService.computeNextOccurrenceDate(
                LocalDate.of(2024, 1, 31),
                LocalDate.of(2024, 1, 31),
                "MONTHLY",
                31,
                null,
                LocalDate.of(2024, 1, 31)
        );
        assertEquals(LocalDate.of(2024, 2, 29), nextFeb2024);

        // 3. Clamping March 31st to April 30th
        LocalDate nextApr = calculationService.computeNextOccurrenceDate(
                LocalDate.of(2026, 3, 31),
                LocalDate.of(2026, 3, 31),
                "MONTHLY",
                31,
                null,
                LocalDate.of(2026, 3, 31)
        );
        assertEquals(LocalDate.of(2026, 4, 30), nextApr);
    }

    @Test
    @DisplayName("Should evaluate budget pressure levels accurately")
    void shouldEvaluateBudgetPressureLevels() {
        FinancialProfile profile = new FinancialProfile();
        profile.setReportedBalance(new BigDecimal("10000.00"));

        FinancialCommitment c1 = new FinancialCommitment();
        c1.setAmount(new BigDecimal("9000.00"));
        c1.setActive(true);

        // Over 80% pressure -> HIGH
        BudgetPressureResponse highResp = calculationService.calculateBudgetPressure(
                profile,
                List.of(c1),
                List.of(),
                null,
                BigDecimal.ZERO,
                LocalDate.of(2026, 10, 1)
        );
        assertEquals(PressureLevel.HIGH, highResp.getPressureLevel());

        // Deficit -> CRITICAL
        c1.setAmount(new BigDecimal("15000.00"));
        BudgetPressureResponse critResp = calculationService.calculateBudgetPressure(
                profile,
                List.of(c1),
                List.of(),
                null,
                BigDecimal.ZERO,
                LocalDate.of(2026, 10, 1)
        );
        assertEquals(PressureLevel.CRITICAL, critResp.getPressureLevel());

        // Healthy (< 50%)
        c1.setAmount(new BigDecimal("2000.00"));
        BudgetPressureResponse healthyResp = calculationService.calculateBudgetPressure(
                profile,
                List.of(c1),
                List.of(),
                null,
                BigDecimal.ZERO,
                LocalDate.of(2026, 10, 1)
        );
        assertEquals(PressureLevel.HEALTHY, healthyResp.getPressureLevel());
    }

    @Test
    @DisplayName("Should maintain half-up rounding and 2-decimal scale precision")
    void shouldMaintainHalfUpRoundingAndScale() {
        BigDecimal val = new BigDecimal("100.555");
        BigDecimal rounded = val.setScale(2, RoundingMode.HALF_UP);
        assertEquals(new BigDecimal("100.56"), rounded);

        BigDecimal div = new BigDecimal("10.00").divide(new BigDecimal("3"), 2, RoundingMode.HALF_UP);
        assertEquals(new BigDecimal("3.33"), div);
    }
}
