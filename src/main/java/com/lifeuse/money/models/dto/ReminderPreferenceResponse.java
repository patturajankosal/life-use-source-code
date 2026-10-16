package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.NotificationChannel;

import java.time.Instant;

public class ReminderPreferenceResponse {

    private Long id;
    private Long userId;
    private boolean dailyBudgetReminderEnabled;
    private String dailyReminderTime;
    private int billDueReminderDaysBefore;
    private boolean budgetThresholdWarningEnabled;
    private int budgetThresholdPercent;
    private String quietHoursStart;
    private String quietHoursEnd;
    private NotificationChannel notificationChannel;
    private Instant createdAt;
    private Instant updatedAt;

    public ReminderPreferenceResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public boolean isDailyBudgetReminderEnabled() { return dailyBudgetReminderEnabled; }
    public void setDailyBudgetReminderEnabled(boolean dailyBudgetReminderEnabled) { this.dailyBudgetReminderEnabled = dailyBudgetReminderEnabled; }

    public String getDailyReminderTime() { return dailyReminderTime; }
    public void setDailyReminderTime(String dailyReminderTime) { this.dailyReminderTime = dailyReminderTime; }

    public int getBillDueReminderDaysBefore() { return billDueReminderDaysBefore; }
    public void setBillDueReminderDaysBefore(int billDueReminderDaysBefore) { this.billDueReminderDaysBefore = billDueReminderDaysBefore; }

    public boolean isBudgetThresholdWarningEnabled() { return budgetThresholdWarningEnabled; }
    public void setBudgetThresholdWarningEnabled(boolean budgetThresholdWarningEnabled) { this.budgetThresholdWarningEnabled = budgetThresholdWarningEnabled; }

    public int getBudgetThresholdPercent() { return budgetThresholdPercent; }
    public void setBudgetThresholdPercent(int budgetThresholdPercent) { this.budgetThresholdPercent = budgetThresholdPercent; }

    public String getQuietHoursStart() { return quietHoursStart; }
    public void setQuietHoursStart(String quietHoursStart) { this.quietHoursStart = quietHoursStart; }

    public String getQuietHoursEnd() { return quietHoursEnd; }
    public void setQuietHoursEnd(String quietHoursEnd) { this.quietHoursEnd = quietHoursEnd; }

    public NotificationChannel getNotificationChannel() { return notificationChannel; }
    public void setNotificationChannel(NotificationChannel notificationChannel) { this.notificationChannel = notificationChannel; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }

    public Instant getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Instant updatedAt) { this.updatedAt = updatedAt; }
}
