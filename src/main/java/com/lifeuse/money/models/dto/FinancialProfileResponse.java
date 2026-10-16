package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.CarryForwardRule;

import java.math.BigDecimal;
import java.time.Instant;

public class FinancialProfileResponse {

    private Long id;
    private Long userId;
    private String currency;
    private BigDecimal reportedBalance;
    private BigDecimal emergencyReserve;
    private BigDecimal minimumCashReserve;
    private String weekStartDay;
    private String timezone;
    private CarryForwardRule defaultCarryForward;
    private Instant createdAt;
    private Instant updatedAt;

    public FinancialProfileResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }

    public BigDecimal getReportedBalance() { return reportedBalance; }
    public void setReportedBalance(BigDecimal reportedBalance) { this.reportedBalance = reportedBalance; }

    public BigDecimal getEmergencyReserve() { return emergencyReserve; }
    public void setEmergencyReserve(BigDecimal emergencyReserve) { this.emergencyReserve = emergencyReserve; }

    public BigDecimal getMinimumCashReserve() { return minimumCashReserve; }
    public void setMinimumCashReserve(BigDecimal minimumCashReserve) { this.minimumCashReserve = minimumCashReserve; }

    public String getWeekStartDay() { return weekStartDay; }
    public void setWeekStartDay(String weekStartDay) { this.weekStartDay = weekStartDay; }

    public String getTimezone() { return timezone; }
    public void setTimezone(String timezone) { this.timezone = timezone; }

    public CarryForwardRule getDefaultCarryForward() { return defaultCarryForward; }
    public void setDefaultCarryForward(CarryForwardRule defaultCarryForward) { this.defaultCarryForward = defaultCarryForward; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }

    public Instant getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Instant updatedAt) { this.updatedAt = updatedAt; }
}
