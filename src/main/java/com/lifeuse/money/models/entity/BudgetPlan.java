package com.lifeuse.money.models.entity;

import com.lifeuse.money.models.enums.CarryForwardRule;
import com.lifeuse.money.models.enums.PlanPeriodType;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BudgetPlan {

    private Long id;
    private Long userId;
    private PlanPeriodType periodType;
    private LocalDate startDate;
    private LocalDate endDate;
    private BigDecimal totalBudget;
    private CarryForwardRule carryForwardRule;
    private BigDecimal carriedForwardAmount;
    private boolean active;
    private String notes;
    private List<BudgetCategoryLimit> categoryLimits = new ArrayList<>();
    private Instant createdAt;
    private Instant updatedAt;

    public BudgetPlan() {
        this.carryForwardRule = CarryForwardRule.UNSPENT_ONLY;
        this.carriedForwardAmount = BigDecimal.ZERO;
        this.active = true;
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

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public List<BudgetCategoryLimit> getCategoryLimits() { return categoryLimits; }
    public void setCategoryLimits(List<BudgetCategoryLimit> categoryLimits) { this.categoryLimits = categoryLimits; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }

    public Instant getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Instant updatedAt) { this.updatedAt = updatedAt; }
}
