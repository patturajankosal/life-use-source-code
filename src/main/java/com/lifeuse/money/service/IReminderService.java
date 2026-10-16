package com.lifeuse.money.service;

import com.lifeuse.money.models.dto.*;

import java.util.List;

public interface IReminderService {

    ReminderPreferenceResponse getReminderPreferences(Long userId);

    ReminderPreferenceResponse updateReminderPreferences(Long userId, ReminderPreferenceRequest request);

    List<UserNotificationResponse> getUserNotifications(Long userId, int limit);

    void markNotificationAsRead(Long userId, Long notificationId);

    void evaluateAndGenerateReminders(Long userId);
}
