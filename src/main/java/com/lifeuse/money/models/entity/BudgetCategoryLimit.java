package com.lifeuse.money.models.entity;

import java.math.BigDecimal;

public class BudgetCategoryLimit {

    private Long id;
    private Long budgetPlanId;
    private String categoryName;
    private BigDecimal allocatedAmount;
    private boolean essential;

    public BudgetCategoryLimit() {}

    public BudgetCategoryLimit(String categoryName, BigDecimal allocatedAmount, boolean essential) {
        this.categoryName = categoryName;
        this.allocatedAmount = allocatedAmount;
        this.essential = essential;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getBudgetPlanId() { return budgetPlanId; }
    public void setBudgetPlanId(Long budgetPlanId) { this.budgetPlanId = budgetPlanId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public BigDecimal getAllocatedAmount() { return allocatedAmount; }
    public void setAllocatedAmount(BigDecimal allocatedAmount) { this.allocatedAmount = allocatedAmount; }

    public boolean isEssential() { return essential; }
    public void setEssential(boolean essential) { this.essential = essential; }
}
