package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.OccurrenceStatus;

import java.math.BigDecimal;
import java.time.LocalDate;

public class RecurringOccurrenceResponse {

    private Long id;
    private Long scheduleId;
    private String scheduleTitle;
    private Long userId;
    private LocalDate scheduledDate;
    private BigDecimal amount;
    private OccurrenceStatus status;
    private Long transactionId;

    public RecurringOccurrenceResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getScheduleId() { return scheduleId; }
    public void setScheduleId(Long scheduleId) { this.scheduleId = scheduleId; }

    public String getScheduleTitle() { return scheduleTitle; }
    public void setScheduleTitle(String scheduleTitle) { this.scheduleTitle = scheduleTitle; }

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
}
