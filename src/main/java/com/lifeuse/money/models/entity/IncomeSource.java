package com.lifeuse.money.models.entity;

import com.lifeuse.money.models.enums.IncomeFrequency;

import java.math.BigDecimal;
import java.time.Instant;

public class IncomeSource {

    private Long id;
    private Long userId;
    private String sourceName;
    private BigDecimal amount;
    private IncomeFrequency frequency;
    private Integer expectedDayOfMonth;
    private boolean active;
    private String notes;
    private Instant createdAt;
    private Instant updatedAt;

    public IncomeSource() {
        this.frequency = IncomeFrequency.MONTHLY;
        this.active = true;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getSourceName() { return sourceName; }
    public void setSourceName(String sourceName) { this.sourceName = sourceName; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public IncomeFrequency getFrequency() { return frequency; }
    public void setFrequency(IncomeFrequency frequency) { this.frequency = frequency; }

    public Integer getExpectedDayOfMonth() { return expectedDayOfMonth; }
    public void setExpectedDayOfMonth(Integer expectedDayOfMonth) { this.expectedDayOfMonth = expectedDayOfMonth; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }

    public Instant getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Instant updatedAt) { this.updatedAt = updatedAt; }
}
