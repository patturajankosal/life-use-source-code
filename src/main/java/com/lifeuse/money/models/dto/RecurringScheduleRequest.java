package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.PaymentMethod;
import com.lifeuse.money.models.enums.RecurrenceFrequency;
import com.lifeuse.money.models.enums.TransactionType;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDate;

public class RecurringScheduleRequest {

    @NotBlank(message = "Title is required")
    private String title;

    @NotNull(message = "Transaction type is required")
    private TransactionType transactionType;

    private String categoryName;

    @NotNull(message = "Amount is required")
    @DecimalMin(value = "0.01", message = "Amount must be greater than zero")
    private BigDecimal amount;

    @NotNull(message = "Frequency is required")
    private RecurrenceFrequency frequency;

    @NotNull(message = "Start date is required")
    private LocalDate startDate;

    private LocalDate endDate;

    @Min(value = 1, message = "Day of month must be between 1 and 31")
    @Max(value = 31, message = "Day of month must be between 1 and 31")
    private Integer dayOfMonth;

    private String dayOfWeek;
    private Boolean essential;
    private PaymentMethod paymentMethod;

    public RecurringScheduleRequest() {
        this.transactionType = TransactionType.EXPENSE;
        this.frequency = RecurrenceFrequency.MONTHLY;
        this.paymentMethod = PaymentMethod.UPI;
        this.essential = false;
    }

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

    public Boolean getEssential() { return essential; }
    public void setEssential(Boolean essential) { this.essential = essential; }

    public PaymentMethod getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(PaymentMethod paymentMethod) { this.paymentMethod = paymentMethod; }
}
