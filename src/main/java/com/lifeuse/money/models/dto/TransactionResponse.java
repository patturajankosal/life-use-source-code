package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.PaymentMethod;
import com.lifeuse.money.models.enums.TransactionType;

import java.math.BigDecimal;
import java.time.Instant;

public class TransactionResponse {

    private Long id;
    private Long userId;
    private TransactionType transactionType;
    private String categoryName;
    private String subCategory;
    private BigDecimal amount;
    private String currency;
    private PaymentMethod paymentMethod;
    private Instant transactionDate;
    private boolean essential;
    private String idempotencyKey;
    private String notes;
    private Long plannedExpenseId;
    private Long recurringOccurrenceId;
    private Instant createdAt;

    public TransactionResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public TransactionType getTransactionType() { return transactionType; }
    public void setTransactionType(TransactionType transactionType) { this.transactionType = transactionType; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getSubCategory() { return subCategory; }
    public void setSubCategory(String subCategory) { this.subCategory = subCategory; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }

    public PaymentMethod getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(PaymentMethod paymentMethod) { this.paymentMethod = paymentMethod; }

    public Instant getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Instant transactionDate) { this.transactionDate = transactionDate; }

    public boolean isEssential() { return essential; }
    public void setEssential(boolean essential) { this.essential = essential; }

    public String getIdempotencyKey() { return idempotencyKey; }
    public void setIdempotencyKey(String idempotencyKey) { this.idempotencyKey = idempotencyKey; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Long getPlannedExpenseId() { return plannedExpenseId; }
    public void setPlannedExpenseId(Long plannedExpenseId) { this.plannedExpenseId = plannedExpenseId; }

    public Long getRecurringOccurrenceId() { return recurringOccurrenceId; }
    public void setRecurringOccurrenceId(Long recurringOccurrenceId) { this.recurringOccurrenceId = recurringOccurrenceId; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }
}
