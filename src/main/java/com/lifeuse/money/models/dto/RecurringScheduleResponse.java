package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.PaymentMethod;
import com.lifeuse.money.models.enums.RecurrenceFrequency;
import com.lifeuse.money.models.enums.TransactionType;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

public class RecurringScheduleResponse {

    private Long id;
    private Long userId;
    private String title;
    private TransactionType transactionType;
    private String categoryName;
    private BigDecimal amount;
    private RecurrenceFrequency frequency;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer dayOfMonth;
    private String dayOfWeek;
    private boolean essential;
    private PaymentMethod paymentMethod;
    private boolean active;
    private LocalDate nextOccurrenceDate;
    private Instant createdAt;

    public RecurringScheduleResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public TransactionType getTransactionType() { return transactionType; }
    public void setTransactionType(TransactionType transactionType) { this.transactionType = transactionType; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public RecurrenceFrequency getFrequency() { return frequency; }
    public void setFrequency(RecurrenceFrequency frequency) { this.frequency = frequency; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public Integer getDayOfMonth() { return dayOfMonth; }
    public void setDayOfMonth(Integer dayOfMonth) { this.dayOfMonth = dayOfMonth; }

    public String getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(String dayOfWeek) { this.dayOfWeek = dayOfWeek; }

    public boolean isEssential() { return essential; }
    public void setEssential(boolean essential) { this.essential = essential; }

    public PaymentMethod getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(PaymentMethod paymentMethod) { this.paymentMethod = paymentMethod; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public LocalDate getNextOccurrenceDate() { return nextOccurrenceDate; }
    public void setNextOccurrenceDate(LocalDate nextOccurrenceDate) { this.nextOccurrenceDate = nextOccurrenceDate; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }
}
