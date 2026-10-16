package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.CommitmentType;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public class FinancialCommitmentRequest {

    @NotBlank(message = "Title is required")
    private String title;

    @NotNull(message = "Commitment type is required")
    private CommitmentType commitmentType;

    @NotNull(message = "Amount is required")
    @DecimalMin(value = "0.01", message = "Amount must be greater than zero")
    private BigDecimal amount;

    @NotNull(message = "Due day of month is required")
    @Min(value = 1, message = "Due day must be between 1 and 31")
    @Max(value = 31, message = "Due day must be between 1 and 31")
    private Integer dueDayOfMonth;

    private String frequency;
    private Boolean essential;
    private Boolean active;
    private String notes;

    public FinancialCommitmentRequest() {
        this.frequency = "MONTHLY";
        this.essential = true;
        this.active = true;
    }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public CommitmentType getCommitmentType() { return commitmentType; }
    public void setCommitmentType(CommitmentType commitmentType) { this.commitmentType = commitmentType; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public Integer getDueDayOfMonth() { return dueDayOfMonth; }
    public void setDueDayOfMonth(Integer dueDayOfMonth) { this.dueDayOfMonth = dueDayOfMonth; }

    public String getFrequency() { return frequency; }
    public void setFrequency(String frequency) { this.frequency = frequency; }

    public Boolean getEssential() { return essential; }
    public void setEssential(Boolean essential) { this.essential = essential; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
