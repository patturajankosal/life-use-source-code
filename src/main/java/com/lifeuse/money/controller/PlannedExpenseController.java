package com.lifeuse.money.controller;

import com.lifeuse.AppRoutes;
import com.lifeuse.common.ApiResponse;
import com.lifeuse.money.models.dto.PlannedExpenseRequest;
import com.lifeuse.money.models.dto.PlannedExpenseResponse;
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
@Tag(name = "Money Planned Expenses", description = "Special-day and upcoming planned expense endpoints")
public class PlannedExpenseController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(PlannedExpenseController.class);

    private final IMoneyService moneyService;
    private final IUserService userService;

    public PlannedExpenseController(IMoneyService moneyService, IUserService userService) {
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

    @GetMapping(AppRoutes.Money.GET_PLANNED_EXPENSES)
    @Operation(summary = "List all planned expenses for user", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<List<PlannedExpenseResponse>>> getPlannedExpenses(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            List<PlannedExpenseResponse> list = moneyService.getPlannedExpenses(userId);
            return ApiResponse.ok("Planned expenses retrieved successfully", list);
        } catch (Exception ex) {
            log.error("PlannedExpense", "Failed to retrieve planned expenses: {}", ex.getMessage());
            throw ex;
        }
    }

    @PostMapping(AppRoutes.Money.POST_PLANNED_EXPENSE)
    @Operation(summary = "Schedule a planned expense or special-day spending", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<PlannedExpenseResponse>> createPlannedExpense(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody PlannedExpenseRequest request
    ) {
        try {
            Long userId = getUserId(userDetails);
            PlannedExpenseResponse resp = moneyService.createPlannedExpense(userId, request);
            log.success("PlannedExpense", "Scheduled planned expense '{}' of ₹{} on {} for user {}", resp.getTitle(), resp.getAmount(), resp.getPlannedDate(), userId);
            return ApiResponse.created("Planned expense scheduled successfully", resp);
        } catch (Exception ex) {
            log.error("PlannedExpense", "Failed to schedule planned expense: {}", ex.getMessage());
            throw ex;
        }
    }

    @DeleteMapping(AppRoutes.Money.DELETE_PLANNED_EXPENSE)
    @Operation(summary = "Delete planned expense", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<Void>> deletePlannedExpense(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            moneyService.deletePlannedExpense(userId, id);
            log.success("PlannedExpense", "Deleted planned expense {} for user {}", id, userId);
            return ApiResponse.ok("Planned expense deleted successfully", null);
        } catch (Exception ex) {
            log.error("PlannedExpense", "Failed to delete planned expense {}: {}", id, ex.getMessage());
            throw ex;
        }
    }

    @PostMapping(AppRoutes.Money.POST_EXECUTE_PLANNED_EXP)
    @Operation(summary = "Execute planned expense into an actual transaction", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<TransactionResponse>> executePlannedExpense(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            TransactionResponse tx = moneyService.executePlannedExpense(userId, id);
            log.success("PlannedExpense", "Executed planned expense {} into transaction {} for user {}", id, tx.getId(), userId);
            return ApiResponse.ok("Planned expense executed into transaction successfully", tx);
        } catch (Exception ex) {
            log.error("PlannedExpense", "Failed to execute planned expense {}: {}", id, ex.getMessage());
            throw ex;
        }
    }
}
