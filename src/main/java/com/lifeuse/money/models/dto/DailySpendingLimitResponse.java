package com.lifeuse.money.models.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class DailySpendingLimitResponse {

    private BigDecimal recommendedDailyLimit;
    private BigDecimal spentToday;
    private BigDecimal remainingTodayAllowance;
    private BigDecimal reportedFunds;
    private BigDecimal calculatedAvailableFunds;
    private BigDecimal reservedForCommitments;
    private BigDecimal reservedForSavings;
    private BigDecimal plannedExpensesAhead;
    private BigDecimal emergencyReserve;
    private BigDecimal remainingDiscretionaryBudget;
    private int remainingDaysInPeriod;
    private BigDecimal budgetUtilizationPercent;
    private Instant calculatedAt;
    private String explanation;
    private List<String> warnings = new ArrayList<>();
    private List<String> actionableInsights = new ArrayList<>();

    public DailySpendingLimitResponse() {
        this.recommendedDailyLimit = BigDecimal.ZERO;
        this.spentToday = BigDecimal.ZERO;
        this.remainingTodayAllowance = BigDecimal.ZERO;
        this.reportedFunds = BigDecimal.ZERO;
        this.calculatedAvailableFunds = BigDecimal.ZERO;
        this.reservedForCommitments = BigDecimal.ZERO;
        this.reservedForSavings = BigDecimal.ZERO;
        this.plannedExpensesAhead = BigDecimal.ZERO;
        this.emergencyReserve = BigDecimal.ZERO;
        this.remainingDiscretionaryBudget = BigDecimal.ZERO;
        this.budgetUtilizationPercent = BigDecimal.ZERO;
        this.calculatedAt = Instant.now();
    }

    public BigDecimal getRecommendedDailyLimit() { return recommendedDailyLimit; }
    public void setRecommendedDailyLimit(BigDecimal recommendedDailyLimit) { this.recommendedDailyLimit = recommendedDailyLimit; }

    public BigDecimal getSpentToday() { return spentToday; }
    public void setSpentToday(BigDecimal spentToday) { this.spentToday = spentToday; }

    public BigDecimal getRemainingTodayAllowance() { return remainingTodayAllowance; }
    public void setRemainingTodayAllowance(BigDecimal remainingTodayAllowance) { this.remainingTodayAllowance = remainingTodayAllowance; }

    public BigDecimal getReportedFunds() { return reportedFunds; }
    public void setReportedFunds(BigDecimal reportedFunds) { this.reportedFunds = reportedFunds; }

    public BigDecimal getCalculatedAvailableFunds() { return calculatedAvailableFunds; }
    public void setCalculatedAvailableFunds(BigDecimal calculatedAvailableFunds) { this.calculatedAvailableFunds = calculatedAvailableFunds; }

    public BigDecimal getReservedForCommitments() { return reservedForCommitments; }
    public void setReservedForCommitments(BigDecimal reservedForCommitments) { this.reservedForCommitments = reservedForCommitments; }

    public BigDecimal getReservedForSavings() { return reservedForSavings; }
    public void setReservedForSavings(BigDecimal reservedForSavings) { this.reservedForSavings = reservedForSavings; }

    public BigDecimal getPlannedExpensesAhead() { return plannedExpensesAhead; }
    public void setPlannedExpensesAhead(BigDecimal plannedExpensesAhead) { this.plannedExpensesAhead = plannedExpensesAhead; }

    public BigDecimal getEmergencyReserve() { return emergencyReserve; }
    public void setEmergencyReserve(BigDecimal emergencyReserve) { this.emergencyReserve = emergencyReserve; }

    public BigDecimal getRemainingDiscretionaryBudget() { return remainingDiscretionaryBudget; }
    public void setRemainingDiscretionaryBudget(BigDecimal remainingDiscretionaryBudget) { this.remainingDiscretionaryBudget = remainingDiscretionaryBudget; }

    public int getRemainingDaysInPeriod() { return remainingDaysInPeriod; }
    public void setRemainingDaysInPeriod(int remainingDaysInPeriod) { this.remainingDaysInPeriod = remainingDaysInPeriod; }

    public BigDecimal getBudgetUtilizationPercent() { return budgetUtilizationPercent; }
    public void setBudgetUtilizationPercent(BigDecimal budgetUtilizationPercent) { this.budgetUtilizationPercent = budgetUtilizationPercent; }

    public Instant getCalculatedAt() { return calculatedAt; }
    public void setCalculatedAt(Instant calculatedAt) { this.calculatedAt = calculatedAt; }

    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }

    public List<String> getWarnings() { return warnings; }
    public void setWarnings(List<String> warnings) { this.warnings = warnings; }

    public List<String> getActionableInsights() { return actionableInsights; }
    public void setActionableInsights(List<String> actionableInsights) { this.actionableInsights = actionableInsights; }
}
