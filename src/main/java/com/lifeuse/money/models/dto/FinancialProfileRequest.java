package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.CarryForwardRule;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public class FinancialProfileRequest {

    @NotBlank(message = "Currency is required")
    private String currency;

    @NotNull(message = "Reported balance is required")
    @DecimalMin(value = "0.0", inclusive = true, message = "Reported balance must be non-negative")
    private BigDecimal reportedBalance;

    @DecimalMin(value = "0.0", inclusive = true, message = "Emergency reserve must be non-negative")
    private BigDecimal emergencyReserve;

    @DecimalMin(value = "0.0", inclusive = true, message = "Minimum cash reserve must be non-negative")
    private BigDecimal minimumCashReserve;

    private String weekStartDay;
    private String timezone;
    private CarryForwardRule defaultCarryForward;

    public FinancialProfileRequest() {
        this.currency = "INR";
        this.reportedBalance = BigDecimal.ZERO;
        this.emergencyReserve = BigDecimal.ZERO;
        this.minimumCashReserve = BigDecimal.ZERO;
        this.weekStartDay = "MONDAY";
        this.timezone = "Asia/Kolkata";
        this.defaultCarryForward = CarryForwardRule.UNSPENT_ONLY;
    }

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
}
