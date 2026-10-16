package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.CarryForwardRule;
import com.lifeuse.money.models.enums.PlanPeriodType;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BudgetPlanResponse {

    private Long id;
    private Long userId;
    private PlanPeriodType periodType;
    private LocalDate startDate;
    private LocalDate endDate;
    private BigDecimal totalBudget;
    private CarryForwardRule carryForwardRule;
    private BigDecimal carriedForwardAmount;
    private BigDecimal actualExpenses;
    private BigDecimal remainingBudget;
    private BigDecimal dailyRecommendedSpending;
    private BigDecimal periodUtilizationPercent;
    private boolean active;
    private String notes;
    private List<BudgetCategoryLimitDto> categoryLimits = new ArrayList<>();
    private Instant createdAt;

    public BudgetPlanResponse() {
        this.carriedForwardAmount = BigDecimal.ZERO;
        this.actualExpenses = BigDecimal.ZERO;
        this.remainingBudget = BigDecimal.ZERO;
        this.dailyRecommendedSpending = BigDecimal.ZERO;
        this.periodUtilizationPercent = BigDecimal.ZERO;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public PlanPeriodType getPeriodType() { return periodType; }
    public void setPeriodType(PlanPeriodType periodType) { this.periodType = periodType; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public BigDecimal getTotalBudget() { return totalBudget; }
    public void setTotalBudget(BigDecimal totalBudget) { this.totalBudget = totalBudget; }

    public CarryForwardRule getCarryForwardRule() { return carryForwardRule; }
    public void setCarryForwardRule(CarryForwardRule carryForwardRule) { this.carryForwardRule = carryForwardRule; }

    public BigDecimal getCarriedForwardAmount() { return carriedForwardAmount; }
    public void setCarriedForwardAmount(BigDecimal carriedForwardAmount) { this.carriedForwardAmount = carriedForwardAmount; }

    public BigDecimal getActualExpenses() { return actualExpenses; }
    public void setActualExpenses(BigDecimal actualExpenses) { this.actualExpenses = actualExpenses; }

    public BigDecimal getRemainingBudget() { return remainingBudget; }
    public void setRemainingBudget(BigDecimal remainingBudget) { this.remainingBudget = remainingBudget; }

    public BigDecimal getDailyRecommendedSpending() { return dailyRecommendedSpending; }
    public void setDailyRecommendedSpending(BigDecimal dailyRecommendedSpending) { this.dailyRecommendedSpending = dailyRecommendedSpending; }

    public BigDecimal getPeriodUtilizationPercent() { return periodUtilizationPercent; }
    public void setPeriodUtilizationPercent(BigDecimal periodUtilizationPercent) { this.periodUtilizationPercent = periodUtilizationPercent; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public List<BudgetCategoryLimitDto> getCategoryLimits() { return categoryLimits; }
    public void setCategoryLimits(List<BudgetCategoryLimitDto> categoryLimits) { this.categoryLimits = categoryLimits; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }
}
