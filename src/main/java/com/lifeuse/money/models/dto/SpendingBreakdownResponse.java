package com.lifeuse.money.models.dto;

import java.math.BigDecimal;
import java.util.Map;

public class SpendingBreakdownResponse {

    private BigDecimal totalIncomeMonth;
    private BigDecimal totalExpensesMonth;
    private BigDecimal totalCommitmentsMonth;
    private BigDecimal totalSavingsMonth;
    private BigDecimal plannedExpensesMonth;
    private BigDecimal unallocatedDiscretionary;
    private Map<String, BigDecimal> breakdownByCategory;
    private Map<String, BigDecimal> commitmentsByType;

    public SpendingBreakdownResponse() {
        this.totalIncomeMonth = BigDecimal.ZERO;
        this.totalExpensesMonth = BigDecimal.ZERO;
        this.totalCommitmentsMonth = BigDecimal.ZERO;
        this.totalSavingsMonth = BigDecimal.ZERO;
        this.plannedExpensesMonth = BigDecimal.ZERO;
        this.unallocatedDiscretionary = BigDecimal.ZERO;
    }

    public BigDecimal getTotalIncomeMonth() { return totalIncomeMonth; }
    public void setTotalIncomeMonth(BigDecimal totalIncomeMonth) { this.totalIncomeMonth = totalIncomeMonth; }

    public BigDecimal getTotalExpensesMonth() { return totalExpensesMonth; }
    public void setTotalExpensesMonth(BigDecimal totalExpensesMonth) { this.totalExpensesMonth = totalExpensesMonth; }

    public BigDecimal getTotalCommitmentsMonth() { return totalCommitmentsMonth; }
    public void setTotalCommitmentsMonth(BigDecimal totalCommitmentsMonth) { this.totalCommitmentsMonth = totalCommitmentsMonth; }

    public BigDecimal getTotalSavingsMonth() { return totalSavingsMonth; }
    public void setTotalSavingsMonth(BigDecimal totalSavingsMonth) { this.totalSavingsMonth = totalSavingsMonth; }

    public BigDecimal getPlannedExpensesMonth() { return plannedExpensesMonth; }
    public void setPlannedExpensesMonth(BigDecimal plannedExpensesMonth) { this.plannedExpensesMonth = plannedExpensesMonth; }

    public BigDecimal getUnallocatedDiscretionary() { return unallocatedDiscretionary; }
    public void setUnallocatedDiscretionary(BigDecimal unallocatedDiscretionary) { this.unallocatedDiscretionary = unallocatedDiscretionary; }

    public Map<String, BigDecimal> getBreakdownByCategory() { return breakdownByCategory; }
    public void setBreakdownByCategory(Map<String, BigDecimal> breakdownByCategory) { this.breakdownByCategory = breakdownByCategory; }

    public Map<String, BigDecimal> getCommitmentsByType() { return commitmentsByType; }
    public void setCommitmentsByType(Map<String, BigDecimal> commitmentsByType) { this.commitmentsByType = commitmentsByType; }
}
