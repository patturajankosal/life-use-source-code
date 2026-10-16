package com.lifeuse.money.models.dto;

import java.math.BigDecimal;
import java.util.Map;

public class TransactionSummaryResponse {

    private BigDecimal totalIncome;
    private BigDecimal totalExpenses;
    private BigDecimal totalRefunds;
    private BigDecimal netCashFlow;
    private BigDecimal essentialExpenses;
    private BigDecimal discretionaryExpenses;
    private long transactionCount;
    private Map<String, BigDecimal> expensesByCategory;

    public TransactionSummaryResponse() {
        this.totalIncome = BigDecimal.ZERO;
        this.totalExpenses = BigDecimal.ZERO;
        this.totalRefunds = BigDecimal.ZERO;
        this.netCashFlow = BigDecimal.ZERO;
        this.essentialExpenses = BigDecimal.ZERO;
        this.discretionaryExpenses = BigDecimal.ZERO;
    }

    public BigDecimal getTotalIncome() { return totalIncome; }
    public void setTotalIncome(BigDecimal totalIncome) { this.totalIncome = totalIncome; }

    public BigDecimal getTotalExpenses() { return totalExpenses; }
    public void setTotalExpenses(BigDecimal totalExpenses) { this.totalExpenses = totalExpenses; }

    public BigDecimal getTotalRefunds() { return totalRefunds; }
    public void setTotalRefunds(BigDecimal totalRefunds) { this.totalRefunds = totalRefunds; }

    public BigDecimal getNetCashFlow() { return netCashFlow; }
    public void setNetCashFlow(BigDecimal netCashFlow) { this.netCashFlow = netCashFlow; }

    public BigDecimal getEssentialExpenses() { return essentialExpenses; }
    public void setEssentialExpenses(BigDecimal essentialExpenses) { this.essentialExpenses = essentialExpenses; }

    public BigDecimal getDiscretionaryExpenses() { return discretionaryExpenses; }
    public void setDiscretionaryExpenses(BigDecimal discretionaryExpenses) { this.discretionaryExpenses = discretionaryExpenses; }

    public long getTransactionCount() { return transactionCount; }
    public void setTransactionCount(long transactionCount) { this.transactionCount = transactionCount; }

    public Map<String, BigDecimal> getExpensesByCategory() { return expensesByCategory; }
    public void setExpensesByCategory(Map<String, BigDecimal> expensesByCategory) { this.expensesByCategory = expensesByCategory; }
}
