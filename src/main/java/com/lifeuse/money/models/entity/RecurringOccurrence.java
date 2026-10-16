package com.lifeuse.money.models.entity;

import com.lifeuse.money.models.enums.OccurrenceStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

public class RecurringOccurrence {

    private Long id;
    private Long scheduleId;
    private Long userId;
    private LocalDate scheduledDate;
    private BigDecimal amount;
    private OccurrenceStatus status;
    private Long transactionId;
    private Instant createdAt;
    private Instant updatedAt;

    public RecurringOccurrence() {
        this.status = OccurrenceStatus.PENDING;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getScheduleId() { return scheduleId; }
    public void setScheduleId(Long scheduleId) { this.scheduleId = scheduleId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public LocalDate getScheduledDate() { return scheduledDate; }
    public void setScheduledDate(LocalDate scheduledDate) { this.scheduledDate = scheduledDate; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public OccurrenceStatus getStatus() { return status; }
    public void setStatus(OccurrenceStatus status) { this.status = status; }

    public Long getTransactionId() { return transactionId; }
    public void setTransactionId(Long transactionId) { this.transactionId = transactionId; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }

    public Instant getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Instant updatedAt) { this.updatedAt = updatedAt; }
}
