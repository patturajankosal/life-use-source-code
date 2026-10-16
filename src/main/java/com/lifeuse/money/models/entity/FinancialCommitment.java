package com.lifeuse.money.models.entity;

import com.lifeuse.money.models.enums.CommitmentType;

import java.math.BigDecimal;
import java.time.Instant;

public class FinancialCommitment {

    private Long id;
    private Long userId;
    private String title;
    private CommitmentType commitmentType;
    private BigDecimal amount;
    private Integer dueDayOfMonth;
    private String frequency;
    private boolean essential;
    private boolean active;
    private String notes;
    private Instant createdAt;
    private Instant updatedAt;

    public FinancialCommitment() {
        this.frequency = "MONTHLY";
        this.essential = true;
        this.active = true;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

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

    public boolean isEssential() { return essential; }
    public void setEssential(boolean essential) { this.essential = essential; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }

    public Instant getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Instant updatedAt) { this.updatedAt = updatedAt; }
}
