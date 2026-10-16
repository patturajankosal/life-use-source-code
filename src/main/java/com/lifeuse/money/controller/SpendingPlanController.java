package com.lifeuse.money.controller;

import com.lifeuse.AppRoutes;
import com.lifeuse.common.ApiResponse;
import com.lifeuse.money.models.dto.*;
import com.lifeuse.money.service.IMoneyService;
import com.lifeuse.user.models.User;
import com.lifeuse.user.service.IUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "Money Intelligent Spending Plan", description = "Daily limit and budget pressure calculation endpoints")
public class SpendingPlanController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(SpendingPlanController.class);

    private final IMoneyService moneyService;
    private final IUserService userService;

    public SpendingPlanController(IMoneyService moneyService, IUserService userService) {
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

    @GetMapping(AppRoutes.Money.GET_DAILY_LIMIT)
    @Operation(summary = "Calculate intelligent daily spending limit", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<DailySpendingLimitResponse>> getDailySpendingLimit(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            DailySpendingLimitResponse resp = moneyService.getDailySpendingLimit(userId);
            log.success("SpendingPlan", "Calculated daily spending limit ₹{} for user {}", resp.getRecommendedDailyLimit(), userId);
            return ApiResponse.ok("Daily spending limit calculated successfully", resp);
        } catch (Exception ex) {
            log.error("SpendingPlan", "Failed to calculate daily spending limit: {}", ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_SPENDING_BREAKDOWN)
    @Operation(summary = "Get current monthly spending and obligation breakdown", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<SpendingBreakdownResponse>> getSpendingBreakdown(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            SpendingBreakdownResponse resp = moneyService.getSpendingBreakdown(userId);
            return ApiResponse.ok("Spending breakdown retrieved successfully", resp);
        } catch (Exception ex) {
            log.error("SpendingPlan", "Failed to retrieve spending breakdown: {}", ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_BUDGET_PRESSURE)
    @Operation(summary = "Evaluate financial budget pressure and forward projection", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<BudgetPressureResponse>> getBudgetPressure(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            BudgetPressureResponse resp = moneyService.getBudgetPressure(userId);
            return ApiResponse.ok("Budget pressure evaluated successfully", resp);
        } catch (Exception ex) {
            log.error("SpendingPlan", "Failed to evaluate budget pressure: {}", ex.getMessage());
            throw ex;
        }
    }
}
