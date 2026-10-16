package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.IncomeFrequency;

import java.math.BigDecimal;
import java.time.Instant;

public class IncomeSourceResponse {

    private Long id;
    private Long userId;
    private String sourceName;
    private BigDecimal amount;
    private IncomeFrequency frequency;
    private Integer expectedDayOfMonth;
    private boolean active;
    private String notes;
    private Instant createdAt;

    public IncomeSourceResponse() {}

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
}
