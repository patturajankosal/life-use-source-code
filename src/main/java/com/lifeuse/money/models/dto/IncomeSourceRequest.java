package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.IncomeFrequency;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public class IncomeSourceRequest {

    @NotBlank(message = "Source name is required")
    private String sourceName;

    @NotNull(message = "Amount is required")
    @DecimalMin(value = "0.01", message = "Amount must be greater than zero")
    private BigDecimal amount;

    @NotNull(message = "Frequency is required")
    private IncomeFrequency frequency;

    private Integer expectedDayOfMonth;
    private Boolean active;
    private String notes;

    public IncomeSourceRequest() {
        this.frequency = IncomeFrequency.MONTHLY;
        this.active = true;
    }

    public String getSourceName() { return sourceName; }
    public void setSourceName(String sourceName) { this.sourceName = sourceName; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public IncomeFrequency getFrequency() { return frequency; }
    public void setFrequency(IncomeFrequency frequency) { this.frequency = frequency; }

    public Integer getExpectedDayOfMonth() { return expectedDayOfMonth; }
    public void setExpectedDayOfMonth(Integer expectedDayOfMonth) { this.expectedDayOfMonth = expectedDayOfMonth; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
