package com.lifeuse.money.controller;

import com.lifeuse.AppRoutes;
import com.lifeuse.common.ApiResponse;
import com.lifeuse.money.models.dto.RecurringOccurrenceResponse;
import com.lifeuse.money.models.dto.RecurringScheduleRequest;
import com.lifeuse.money.models.dto.RecurringScheduleResponse;
import com.lifeuse.money.models.dto.TransactionResponse;
import com.lifeuse.money.service.IMoneyService;
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
@Tag(name = "Money Recurring Schedules", description = "Recurring transaction schedules and occurrence management")
public class RecurringScheduleController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(RecurringScheduleController.class);

    private final IMoneyService moneyService;
    private final IUserService userService;

    public RecurringScheduleController(IMoneyService moneyService, IUserService userService) {
        this.moneyService = moneyService;
        this.userService = userService;
    }

    private Long getUserId(UserDetails userDetails) {
        if (userDetails instanceof User user) {
            return user.getId();
        }
        User user = (User) userService.loadUserByUsername(userDetails.getUsername());
        return user.getId();
    }

    @GetMapping(AppRoutes.Money.GET_RECURRING_SCHEDULES)
    @Operation(summary = "List all recurring schedules", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<List<RecurringScheduleResponse>>> getRecurringSchedules(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            List<RecurringScheduleResponse> list = moneyService.getRecurringSchedules(userId);
            return ApiResponse.ok("Recurring schedules retrieved successfully", list);
        } catch (Exception ex) {
            log.error("RecurringSchedule", "Failed to retrieve recurring schedules: {}", ex.getMessage());
            throw ex;
        }
    }

    @PostMapping(AppRoutes.Money.POST_RECURRING_SCHEDULE)
    @Operation(summary = "Create recurring transaction schedule", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<RecurringScheduleResponse>> createRecurringSchedule(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody RecurringScheduleRequest request
    ) {
        try {
            Long userId = getUserId(userDetails);
            RecurringScheduleResponse resp = moneyService.createRecurringSchedule(userId, request);
            log.success("RecurringSchedule", "Created recurring schedule '{}' of ₹{} ({}) for user {}", resp.getTitle(), resp.getAmount(), resp.getFrequency(), userId);
            return ApiResponse.created("Recurring schedule created successfully", resp);
        } catch (Exception ex) {
            log.error("RecurringSchedule", "Failed to create recurring schedule: {}", ex.getMessage());
            throw ex;
        }
    }

    @DeleteMapping(AppRoutes.Money.DELETE_RECURRING_SCHEDULE)
    @Operation(summary = "Delete recurring schedule", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<Void>> deleteRecurringSchedule(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            moneyService.deleteRecurringSchedule(userId, id);
            log.success("RecurringSchedule", "Deleted recurring schedule {} for user {}", id, userId);
            return ApiResponse.ok("Recurring schedule deleted successfully", null);
        } catch (Exception ex) {
            log.error("RecurringSchedule", "Failed to delete recurring schedule {}: {}", id, ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_UPCOMING_OCCURRENCES)
    @Operation(summary = "List upcoming occurrences for recurring schedules", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<List<RecurringOccurrenceResponse>>> getUpcomingOccurrences(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            List<RecurringOccurrenceResponse> list = moneyService.getUpcomingOccurrences(userId);
            return ApiResponse.ok("Upcoming occurrences retrieved successfully", list);
        } catch (Exception ex) {
            log.error("RecurringSchedule", "Failed to retrieve upcoming occurrences: {}", ex.getMessage());
            throw ex;
        }
    }

    @PostMapping(AppRoutes.Money.POST_PROCESS_OCCURRENCE)
    @Operation(summary = "Process recurring occurrence into actual transaction", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<TransactionResponse>> processOccurrence(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            TransactionResponse tx = moneyService.processOccurrence(userId, id);
            log.success("RecurringSchedule", "Processed occurrence {} into transaction {} for user {}", id, tx.getId(), userId);
            return ApiResponse.ok("Occurrence processed successfully into transaction", tx);
        } catch (Exception ex) {
            log.error("RecurringSchedule", "Failed to process occurrence {}: {}", id, ex.getMessage());
            throw ex;
        }
    }
}
