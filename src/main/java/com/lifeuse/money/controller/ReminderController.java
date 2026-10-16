package com.lifeuse.money.controller;

import com.lifeuse.AppRoutes;
import com.lifeuse.common.ApiResponse;
import com.lifeuse.money.models.dto.ReminderPreferenceRequest;
import com.lifeuse.money.models.dto.ReminderPreferenceResponse;
import com.lifeuse.money.models.dto.UserNotificationResponse;
import com.lifeuse.money.service.IReminderService;
import com.lifeuse.user.models.User;
import com.lifeuse.user.service.IUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "Money Reminders", description = "Reminder preferences and user financial notifications")
public class ReminderController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(ReminderController.class);

    private final IReminderService reminderService;
    private final IUserService userService;

    public ReminderController(IReminderService reminderService, IUserService userService) {
        this.reminderService = reminderService;
        this.userService = userService;
    }

    private Long getUserId(UserDetails userDetails) {
        if (userDetails instanceof User user) {
            return user.getId();
        }
        User user = (User) userService.loadUserByUsername(userDetails.getUsername());
        return user.getId();
    }

    @GetMapping(AppRoutes.Money.GET_REMINDER_PREFS)
    @Operation(summary = "Get user reminder preferences", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<ReminderPreferenceResponse>> getReminderPreferences(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            ReminderPreferenceResponse resp = reminderService.getReminderPreferences(userId);
            return ApiResponse.ok("Reminder preferences retrieved successfully", resp);
        } catch (Exception ex) {
            log.error("Reminder", "Failed to retrieve reminder preferences: {}", ex.getMessage());
            throw ex;
        }
    }

    @PutMapping(AppRoutes.Money.PUT_REMINDER_PREFS)
    @Operation(summary = "Update reminder preferences", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<ReminderPreferenceResponse>> updateReminderPreferences(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody ReminderPreferenceRequest request
    ) {
        try {
            Long userId = getUserId(userDetails);
            ReminderPreferenceResponse resp = reminderService.updateReminderPreferences(userId, request);
            log.success("Reminder", "Updated reminder preferences for user {}", userId);
            return ApiResponse.ok("Reminder preferences updated successfully", resp);
        } catch (Exception ex) {
            log.error("Reminder", "Failed to update reminder preferences: {}", ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_NOTIFICATIONS)
    @Operation(summary = "List recent notifications for user", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<List<UserNotificationResponse>>> getUserNotifications(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(defaultValue = "20") int limit
    ) {
        try {
            Long userId = getUserId(userDetails);
            // Automatically check & generate any due reminders
            reminderService.evaluateAndGenerateReminders(userId);
            List<UserNotificationResponse> list = reminderService.getUserNotifications(userId, limit);
            return ApiResponse.ok("Notifications retrieved successfully", list);
        } catch (Exception ex) {
            log.error("Reminder", "Failed to retrieve notifications: {}", ex.getMessage());
            throw ex;
        }
    }

    @PutMapping(AppRoutes.Money.PUT_MARK_NOTIFICATION_READ)
    @Operation(summary = "Mark notification as read", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<Void>> markNotificationAsRead(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            reminderService.markNotificationAsRead(userId, id);
            log.success("Reminder", "Marked notification {} as read for user {}", id, userId);
            return ApiResponse.ok("Notification marked as read successfully", null);
        } catch (Exception ex) {
            log.error("Reminder", "Failed to mark notification {} as read: {}", id, ex.getMessage());
            throw ex;
        }
    }
}
