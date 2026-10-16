package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.NotificationChannel;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Pattern;

public class ReminderPreferenceRequest {

    private Boolean dailyBudgetReminderEnabled;

    @Pattern(regexp = "^([01]?[0-9]|2[0-3]):[0-5][0-9]$", message = "Daily reminder time must be in HH:mm format")
    private String dailyReminderTime;

    @Min(value = 0, message = "Days before must be non-negative")
    @Max(value = 30, message = "Days before cannot exceed 30")
    private Integer billDueReminderDaysBefore;

    private Boolean budgetThresholdWarningEnabled;

    @Min(value = 1, message = "Threshold percent must be at least 1")
    @Max(value = 100, message = "Threshold percent cannot exceed 100")
    private Integer budgetThresholdPercent;

    @Pattern(regexp = "^([01]?[0-9]|2[0-3]):[0-5][0-9]$", message = "Quiet hours start must be in HH:mm format")
    private String quietHoursStart;

    @Pattern(regexp = "^([01]?[0-9]|2[0-3]):[0-5][0-9]$", message = "Quiet hours end must be in HH:mm format")
    private String quietHoursEnd;

    private NotificationChannel notificationChannel;

    public ReminderPreferenceRequest() {
        this.dailyBudgetReminderEnabled = true;
        this.dailyReminderTime = "09:00";
        this.billDueReminderDaysBefore = 3;
        this.budgetThresholdWarningEnabled = true;
        this.budgetThresholdPercent = 80;
        this.quietHoursStart = "22:00";
        this.quietHoursEnd = "07:00";
        this.notificationChannel = NotificationChannel.PUSH;
    }

    public Boolean getDailyBudgetReminderEnabled() { return dailyBudgetReminderEnabled; }
    public void setDailyBudgetReminderEnabled(Boolean dailyBudgetReminderEnabled) { this.dailyBudgetReminderEnabled = dailyBudgetReminderEnabled; }

    public String getDailyReminderTime() { return dailyReminderTime; }
    public void setDailyReminderTime(String dailyReminderTime) { this.dailyReminderTime = dailyReminderTime; }

    public Integer getBillDueReminderDaysBefore() { return billDueReminderDaysBefore; }
    public void setBillDueReminderDaysBefore(Integer billDueReminderDaysBefore) { this.billDueReminderDaysBefore = billDueReminderDaysBefore; }

    public Boolean getBudgetThresholdWarningEnabled() { return budgetThresholdWarningEnabled; }
    public void setBudgetThresholdWarningEnabled(Boolean budgetThresholdWarningEnabled) { this.budgetThresholdWarningEnabled = budgetThresholdWarningEnabled; }

    public Integer getBudgetThresholdPercent() { return budgetThresholdPercent; }
    public void setBudgetThresholdPercent(Integer budgetThresholdPercent) { this.budgetThresholdPercent = budgetThresholdPercent; }

    public String getQuietHoursStart() { return quietHoursStart; }
    public void setQuietHoursStart(String quietHoursStart) { this.quietHoursStart = quietHoursStart; }

    public String getQuietHoursEnd() { return quietHoursEnd; }
    public void setQuietHoursEnd(String quietHoursEnd) { this.quietHoursEnd = quietHoursEnd; }

    public NotificationChannel getNotificationChannel() { return notificationChannel; }
    public void setNotificationChannel(NotificationChannel notificationChannel) { this.notificationChannel = notificationChannel; }
}
