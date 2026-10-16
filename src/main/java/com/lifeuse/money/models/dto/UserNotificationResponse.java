package com.lifeuse.money.models.dto;

import com.lifeuse.money.models.enums.ReminderType;

import java.time.Instant;

public class UserNotificationResponse {

    private Long id;
    private Long userId;
    private String title;
    private String message;
    private ReminderType notificationType;
    private boolean read;
    private Instant scheduledAt;
    private Instant createdAt;

    public UserNotificationResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public ReminderType getNotificationType() { return notificationType; }
    public void setNotificationType(ReminderType notificationType) { this.notificationType = notificationType; }

    public boolean isRead() { return read; }
    public void setRead(boolean read) { this.read = read; }

    public Instant getScheduledAt() { return scheduledAt; }
    public void setScheduledAt(Instant scheduledAt) { this.scheduledAt = scheduledAt; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }
}
