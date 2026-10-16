package com.lifeuse.money.models.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

public class PlannedExpenseResponse {

    private Long id;
    private Long userId;
    private String title;
    private BigDecimal amount;
    private LocalDate plannedDate;
    private String categoryName;
    private boolean essential;
    private boolean executed;
    private Long transactionId;
    private String notes;
    private Instant createdAt;

    public PlannedExpenseResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public LocalDate getPlannedDate() { return plannedDate; }
    public void setPlannedDate(LocalDate plannedDate) { this.plannedDate = plannedDate; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public boolean isEssential() { return essential; }
    public void setEssential(boolean essential) { this.essential = essential; }

    public boolean isExecuted() { return executed; }
    public void setExecuted(boolean executed) { this.executed = executed; }

    public Long getTransactionId() { return transactionId; }
    public void setTransactionId(Long transactionId) { this.transactionId = transactionId; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }
}
