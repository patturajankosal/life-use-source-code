package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.CarryForwardRule;
import com.lifeuse.money.models.enums.PlanPeriodType;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BudgetPlanRequest {

    @NotNull(message = "Period type is required")
    private PlanPeriodType periodType;

    @NotNull(message = "Start date is required")
    private LocalDate startDate;

    @NotNull(message = "End date is required")
    private LocalDate endDate;

    @NotNull(message = "Total budget is required")
    @DecimalMin(value = "0.01", message = "Total budget must be greater than zero")
    private BigDecimal totalBudget;

    private CarryForwardRule carryForwardRule;
    private String notes;
    private List<BudgetCategoryLimitDto> categoryLimits = new ArrayList<>();

    public BudgetPlanRequest() {
        this.carryForwardRule = CarryForwardRule.UNSPENT_ONLY;
    }

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

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public List<BudgetCategoryLimitDto> getCategoryLimits() { return categoryLimits; }
    public void setCategoryLimits(List<BudgetCategoryLimitDto> categoryLimits) { this.categoryLimits = categoryLimits; }
}
