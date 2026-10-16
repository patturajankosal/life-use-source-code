package com.lifeuse.money.models.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDate;

public class SavingsGoalRequest {

    @NotBlank(message = "Title is required")
    private String title;

    @NotNull(message = "Target amount is required")
    @DecimalMin(value = "0.01", message = "Target amount must be greater than zero")
    private BigDecimal targetAmount;

    @DecimalMin(value = "0.0", inclusive = true, message = "Current amount must be non-negative")
    private BigDecimal currentAmount;

    @DecimalMin(value = "0.0", inclusive = true, message = "Monthly contribution must be non-negative")
    private BigDecimal monthlyContribution;

    private LocalDate targetDate;
    private Boolean active;

    public SavingsGoalRequest() {
        this.currentAmount = BigDecimal.ZERO;
        this.monthlyContribution = BigDecimal.ZERO;
        this.active = true;
    }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public BigDecimal getTargetAmount() { return targetAmount; }
    public void setTargetAmount(BigDecimal targetAmount) { this.targetAmount = targetAmount; }

    public BigDecimal getCurrentAmount() { return currentAmount; }
    public void setCurrentAmount(BigDecimal currentAmount) { this.currentAmount = currentAmount; }

    public BigDecimal getMonthlyContribution() { return monthlyContribution; }
    public void setMonthlyContribution(BigDecimal monthlyContribution) { this.monthlyContribution = monthlyContribution; }

    public LocalDate getTargetDate() { return targetDate; }
    public void setTargetDate(LocalDate targetDate) { this.targetDate = targetDate; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }
}
