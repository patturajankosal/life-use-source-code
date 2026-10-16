package com.lifeuse.money.controller;

import com.lifeuse.AppRoutes;
import com.lifeuse.common.ApiResponse;
import com.lifeuse.money.models.dto.BudgetPlanRequest;
import com.lifeuse.money.models.dto.BudgetPlanResponse;
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
@Tag(name = "Money Budget Plans", description = "Multi-horizon budget planning endpoints")
public class BudgetPlanController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(BudgetPlanController.class);

    private final IMoneyService moneyService;
    private final IUserService userService;

    public BudgetPlanController(IMoneyService moneyService, IUserService userService) {
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

    @GetMapping(AppRoutes.Money.GET_BUDGET_PLANS)
    @Operation(summary = "List all budget plans for user", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<List<BudgetPlanResponse>>> getBudgetPlans(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            List<BudgetPlanResponse> list = moneyService.getBudgetPlans(userId);
            return ApiResponse.ok("Budget plans retrieved successfully", list);
        } catch (Exception ex) {
            log.error("BudgetPlan", "Failed to retrieve budget plans: {}", ex.getMessage());
            throw ex;
        }
    }

    @PostMapping(AppRoutes.Money.POST_BUDGET_PLAN)
    @Operation(summary = "Create a new budget plan", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<BudgetPlanResponse>> createBudgetPlan(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody BudgetPlanRequest request
    ) {
        try {
            Long userId = getUserId(userDetails);
            BudgetPlanResponse resp = moneyService.createBudgetPlan(userId, request);
            log.success("BudgetPlan", "Created {} budget plan of ₹{} for user {}", resp.getPeriodType(), resp.getTotalBudget(), userId);
            return ApiResponse.created("Budget plan created successfully", resp);
        } catch (Exception ex) {
            log.error("BudgetPlan", "Failed to create budget plan: {}", ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_ACTIVE_BUDGET_PLAN)
    @Operation(summary = "Get currently active budget plan", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<BudgetPlanResponse>> getActiveBudgetPlan(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            BudgetPlanResponse resp = moneyService.getActiveBudgetPlan(userId);
            return ApiResponse.ok("Active budget plan retrieved successfully", resp);
        } catch (Exception ex) {
            log.error("BudgetPlan", "Failed to retrieve active budget plan: {}", ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_BUDGET_PLAN_BY_ID)
    @Operation(summary = "Get budget plan details by ID", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<BudgetPlanResponse>> getBudgetPlanById(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            BudgetPlanResponse resp = moneyService.getBudgetPlanById(userId, id);
            return ApiResponse.ok("Budget plan retrieved successfully", resp);
        } catch (Exception ex) {
            log.error("BudgetPlan", "Failed to retrieve budget plan {}: {}", id, ex.getMessage());
            throw ex;
        }
    }

    @DeleteMapping(AppRoutes.Money.DELETE_BUDGET_PLAN)
    @Operation(summary = "Delete budget plan", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<Void>> deleteBudgetPlan(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            moneyService.deleteBudgetPlan(userId, id);
            log.success("BudgetPlan", "Deleted budget plan {} for user {}", id, userId);
            return ApiResponse.ok("Budget plan deleted successfully", null);
        } catch (Exception ex) {
            log.error("BudgetPlan", "Failed to delete budget plan {}: {}", id, ex.getMessage());
            throw ex;
        }
    }
}
