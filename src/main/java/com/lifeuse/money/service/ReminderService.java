package com.lifeuse.money.service;

import com.lifeuse.common.ApiResponse;
import com.lifeuse.common.BusinessException;
import com.lifeuse.common.ResourceNotFoundException;
import com.lifeuse.common.exception.DatabaseOperationException;
import com.lifeuse.money.models.dto.*;
import com.lifeuse.money.models.entity.*;
import com.lifeuse.money.models.enums.ReminderType;
import com.lifeuse.money.models.mapper.MoneyDtoMapper;
import com.lifeuse.money.repository.IMoneyRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ReminderService implements IReminderService {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(ReminderService.class);

    private final IMoneyRepository moneyRepository;

    public ReminderService(IMoneyRepository moneyRepository) {
        this.moneyRepository = moneyRepository;
    }

    @Override
    public ReminderPreferenceResponse getReminderPreferences(Long userId) {
        try {
            ReminderPreference pref = moneyRepository.findReminderPreferenceByUserId(userId)
                    .orElseGet(() -> {
                        ReminderPreference defaultPref = new ReminderPreference();
                        defaultPref.setUserId(userId);
                        return moneyRepository.saveReminderPreference(defaultPref);
                    });
            return MoneyDtoMapper.toReminderResponse(pref);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve reminder preferences", ex);
        }
    }

    @Override
    @Transactional
    public ReminderPreferenceResponse updateReminderPreferences(Long userId, ReminderPreferenceRequest request) {
        try {
            ReminderPreference pref = moneyRepository.findReminderPreferenceByUserId(userId)
                    .orElseGet(() -> {
                        ReminderPreference p = new ReminderPreference();
                        p.setUserId(userId);
                        return p;
                    });

            if (request.getDailyBudgetReminderEnabled() != null) {
                pref.setDailyBudgetReminderEnabled(request.getDailyBudgetReminderEnabled());
            }
            if (request.getDailyReminderTime() != null) {
                pref.setDailyReminderTime(request.getDailyReminderTime());
            }
            if (request.getBillDueReminderDaysBefore() != null) {
                pref.setBillDueReminderDaysBefore(request.getBillDueReminderDaysBefore());
            }
            if (request.getBudgetThresholdWarningEnabled() != null) {
                pref.setBudgetThresholdWarningEnabled(request.getBudgetThresholdWarningEnabled());
            }
            if (request.getBudgetThresholdPercent() != null) {
                pref.setBudgetThresholdPercent(request.getBudgetThresholdPercent());
            }
            if (request.getQuietHoursStart() != null) {
                pref.setQuietHoursStart(request.getQuietHoursStart());
            }
            if (request.getQuietHoursEnd() != null) {
                pref.setQuietHoursEnd(request.getQuietHoursEnd());
            }
            if (request.getNotificationChannel() != null) {
                pref.setNotificationChannel(request.getNotificationChannel());
            }

            ReminderPreference saved = moneyRepository.saveReminderPreference(pref);
            return MoneyDtoMapper.toReminderResponse(saved);
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to update reminder preferences", ex);
        }
    }

    @Override
    public List<UserNotificationResponse> getUserNotifications(Long userId, int limit) {
        try {
            return moneyRepository.findNotificationsByUserId(userId, limit).stream()
                    .map(MoneyDtoMapper::toNotificationResponse)
                    .collect(Collectors.toList());
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to retrieve notifications", ex);
        }
    }

    @Override
    @Transactional
    public void markNotificationAsRead(Long userId, Long notificationId) {
        try {
            boolean updated = moneyRepository.markNotificationRead(notificationId, userId);
            if (!updated) {
                throw new ResourceNotFoundException("Notification not found or does not belong to you");
            }
        } catch (ResourceNotFoundException ex) {
            throw ex;
        } catch (DatabaseOperationException ex) {
            throw new BusinessException(ApiResponse.ErrorCode.DATABASE_ERROR, "Failed to mark notification as read", ex);
        }
    }

    @Override
    @Transactional
    public void evaluateAndGenerateReminders(Long userId) {
        try {
            ReminderPreference pref = moneyRepository.findReminderPreferenceByUserId(userId).orElse(null);
            if (pref == null) return;

            LocalDate today = LocalDate.now();
            int todayDay = today.getDayOfMonth();
            int daysAhead = pref.getBillDueReminderDaysBefore() > 0 ? pref.getBillDueReminderDaysBefore() : 3;

            List<FinancialCommitment> commitments = moneyRepository.findCommitmentsByUserId(userId);
            for (FinancialCommitment c : commitments) {
                if (!c.isActive()) continue;
                int diff = c.getDueDayOfMonth() - todayDay;
                if (diff >= 0 && diff <= daysAhead) {
                    UserNotification notif = new UserNotification();
                    notif.setUserId(userId);
                    notif.setTitle("Upcoming Payment: " + c.getTitle());
                    notif.setMessage(String.format("Reminder: %s payment of ₹%s is due in %d day(s) on day %d.",
                            c.getTitle(), c.getAmount().toPlainString(), diff, c.getDueDayOfMonth()));
                    notif.setNotificationType(ReminderType.BILL_REMINDER);
                    notif.setScheduledAt(Instant.now());
                    moneyRepository.saveNotification(notif);
                }
            }
        } catch (Exception ex) {
            log.warn("Reminder", "Failed to evaluate and generate automated reminders for user {}: {}", userId, ex.getMessage());
        }
    }

    public boolean isWithinQuietHours(LocalTime currentTime, String startStr, String endStr) {
        if (startStr == null || endStr == null) return false;
        try {
            LocalTime start = LocalTime.parse(startStr);
            LocalTime end = LocalTime.parse(endStr);
            if (start.isBefore(end)) {
                return !currentTime.isBefore(start) && currentTime.isBefore(end);
            } else {
                // Spans midnight, e.g., 22:00 to 07:00
                return !currentTime.isBefore(start) || currentTime.isBefore(end);
            }
        } catch (Exception e) {
            return false;
        }
    }
}
