package com.lifeuse.money.models.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public class BudgetCategoryLimitDto {

    @NotBlank(message = "Category name is required")
    private String categoryName;

    @NotNull(message = "Allocated amount is required")
    @DecimalMin(value = "0.01", message = "Allocated amount must be greater than zero")
    private BigDecimal allocatedAmount;

    private Boolean essential;

    public BudgetCategoryLimitDto() {
        this.essential = false;
    }

    public BudgetCategoryLimitDto(String categoryName, BigDecimal allocatedAmount, Boolean essential) {
        this.categoryName = categoryName;
        this.allocatedAmount = allocatedAmount;
        this.essential = essential != null ? essential : false;
    }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public BigDecimal getAllocatedAmount() { return allocatedAmount; }
    public void setAllocatedAmount(BigDecimal allocatedAmount) { this.allocatedAmount = allocatedAmount; }

    public Boolean getEssential() { return essential; }
    public void setEssential(Boolean essential) { this.essential = essential; }
}
