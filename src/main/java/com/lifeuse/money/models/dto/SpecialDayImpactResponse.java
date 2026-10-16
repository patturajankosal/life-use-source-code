package com.lifeuse.money.models.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class SpecialDayImpactResponse {

    private LocalDate specialDate;
    private BigDecimal specialDayExtraAmount;
    private BigDecimal regularDailyLimitBefore;
    private BigDecimal adjustedDailyLimitOtherDays;
    private BigDecimal specialDayTotalAllowance;
    private String explanation;
    private List<String> alternativeOptions = new ArrayList<>();

    public SpecialDayImpactResponse() {}

    public LocalDate getSpecialDate() { return specialDate; }
    public void setSpecialDate(LocalDate specialDate) { this.specialDate = specialDate; }

    public BigDecimal getSpecialDayExtraAmount() { return specialDayExtraAmount; }
    public void setSpecialDayExtraAmount(BigDecimal specialDayExtraAmount) { this.specialDayExtraAmount = specialDayExtraAmount; }

    public BigDecimal getRegularDailyLimitBefore() { return regularDailyLimitBefore; }
    public void setRegularDailyLimitBefore(BigDecimal regularDailyLimitBefore) { this.regularDailyLimitBefore = regularDailyLimitBefore; }

    public BigDecimal getAdjustedDailyLimitOtherDays() { return adjustedDailyLimitOtherDays; }
    public void setAdjustedDailyLimitOtherDays(BigDecimal adjustedDailyLimitOtherDays) { this.adjustedDailyLimitOtherDays = adjustedDailyLimitOtherDays; }

    public BigDecimal getSpecialDayTotalAllowance() { return specialDayTotalAllowance; }
    public void setSpecialDayTotalAllowance(BigDecimal specialDayTotalAllowance) { this.specialDayTotalAllowance = specialDayTotalAllowance; }

    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }

    public List<String> getAlternativeOptions() { return alternativeOptions; }
    public void setAlternativeOptions(List<String> alternativeOptions) { this.alternativeOptions = alternativeOptions; }
}
