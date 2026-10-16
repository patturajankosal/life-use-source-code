package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.PressureLevel;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class BudgetPressureResponse {

    private PressureLevel pressureLevel;
    private BigDecimal pressureScore; // 0 - 100
    private BigDecimal upcomingCommitmentsTotal;
    private BigDecimal upcomingPlannedExpensesTotal;
    private BigDecimal projectedBalanceAtPeriodEnd;
    private String summaryText;
    private List<String> pressureFactors = new ArrayList<>();
    private List<String> actionableRecommendations = new ArrayList<>();

    public BudgetPressureResponse() {
        this.pressureLevel = PressureLevel.HEALTHY;
        this.pressureScore = BigDecimal.ZERO;
        this.upcomingCommitmentsTotal = BigDecimal.ZERO;
        this.upcomingPlannedExpensesTotal = BigDecimal.ZERO;
        this.projectedBalanceAtPeriodEnd = BigDecimal.ZERO;
    }

    public PressureLevel getPressureLevel() { return pressureLevel; }
    public void setPressureLevel(PressureLevel pressureLevel) { this.pressureLevel = pressureLevel; }

    public BigDecimal getPressureScore() { return pressureScore; }
    public void setPressureScore(BigDecimal pressureScore) { this.pressureScore = pressureScore; }

    public BigDecimal getUpcomingCommitmentsTotal() { return upcomingCommitmentsTotal; }
    public void setUpcomingCommitmentsTotal(BigDecimal upcomingCommitmentsTotal) { this.upcomingCommitmentsTotal = upcomingCommitmentsTotal; }

    public BigDecimal getUpcomingPlannedExpensesTotal() { return upcomingPlannedExpensesTotal; }
    public void setUpcomingPlannedExpensesTotal(BigDecimal upcomingPlannedExpensesTotal) { this.upcomingPlannedExpensesTotal = upcomingPlannedExpensesTotal; }

    public BigDecimal getProjectedBalanceAtPeriodEnd() { return projectedBalanceAtPeriodEnd; }
    public void setProjectedBalanceAtPeriodEnd(BigDecimal projectedBalanceAtPeriodEnd) { this.projectedBalanceAtPeriodEnd = projectedBalanceAtPeriodEnd; }

    public String getSummaryText() { return summaryText; }
    public void setSummaryText(String summaryText) { this.summaryText = summaryText; }

    public List<String> getPressureFactors() { return pressureFactors; }
    public void setPressureFactors(List<String> pressureFactors) { this.pressureFactors = pressureFactors; }

    public List<String> getActionableRecommendations() { return actionableRecommendations; }
    public void setActionableRecommendations(List<String> actionableRecommendations) { this.actionableRecommendations = actionableRecommendations; }
}
