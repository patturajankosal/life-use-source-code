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
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "Money Profile", description = "Financial profile and configuration endpoints")
public class MoneyProfileController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(MoneyProfileController.class);

    private final IMoneyService moneyService;
    private final IUserService userService;

    public MoneyProfileController(IMoneyService moneyService, IUserService userService) {
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

    @GetMapping(AppRoutes.Money.GET_PROFILE)
    @Operation(summary = "Get user financial profile", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<FinancialProfileResponse>> getProfile(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            FinancialProfileResponse resp = moneyService.getProfile(userId);
            log.success("MoneyProfile", "Financial profile retrieved for user {}", userId);
            return ApiResponse.ok("Financial profile retrieved successfully", resp);
        } catch (Exception ex) {
            log.error("MoneyProfile", "Failed to retrieve financial profile: {}", ex.getMessage());
            throw ex;
        }
    }

    @PutMapping(AppRoutes.Money.PUT_PROFILE)
    @Operation(summary = "Update user financial profile", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<FinancialProfileResponse>> updateProfile(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody FinancialProfileRequest request
    ) {
        try {
            Long userId = getUserId(userDetails);
            FinancialProfileResponse resp = moneyService.updateProfile(userId, request);
            log.success("MoneyProfile", "Financial profile updated for user {}", userId);
            return ApiResponse.ok("Financial profile updated successfully", resp);
        } catch (Exception ex) {
            log.error("MoneyProfile", "Failed to update financial profile: {}", ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_INCOME_SOURCES)
    @Operation(summary = "List income sources", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<List<IncomeSourceResponse>>> getIncomeSources(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            List<IncomeSourceResponse> resp = moneyService.getIncomeSources(userId);
            return ApiResponse.ok("Income sources retrieved successfully", resp);
        } catch (Exception ex) {
            log.error("MoneyProfile", "Failed to retrieve income sources: {}", ex.getMessage());
            throw ex;
        }
    }

    @PostMapping(AppRoutes.Money.POST_INCOME_SOURCE)
    @Operation(summary = "Add income source", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<IncomeSourceResponse>> addIncomeSource(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody IncomeSourceRequest request
    ) {
        try {
            Long userId = getUserId(userDetails);
            IncomeSourceResponse resp = moneyService.addIncomeSource(userId, request);
            log.success("MoneyProfile", "Added income source '{}' for user {}", resp.getSourceName(), userId);
            return ApiResponse.created("Income source added successfully", resp);
        } catch (Exception ex) {
            log.error("MoneyProfile", "Failed to add income source: {}", ex.getMessage());
            throw ex;
        }
    }

    @DeleteMapping(AppRoutes.Money.DELETE_INCOME_SOURCE)
    @Operation(summary = "Delete income source", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<Void>> deleteIncomeSource(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            moneyService.deleteIncomeSource(userId, id);
            log.success("MoneyProfile", "Deleted income source {} for user {}", id, userId);
            return ApiResponse.ok("Income source deleted successfully", null);
        } catch (Exception ex) {
            log.error("MoneyProfile", "Failed to delete income source {}: {}", id, ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_COMMITMENTS)
    @Operation(summary = "List financial commitments (EMI, Rent, Bills)", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<List<FinancialCommitmentResponse>>> getCommitments(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            List<FinancialCommitmentResponse> resp = moneyService.getCommitments(userId);
            return ApiResponse.ok("Commitments retrieved successfully", resp);
        } catch (Exception ex) {
            log.error("MoneyProfile", "Failed to retrieve commitments: {}", ex.getMessage());
            throw ex;
        }
    }

    @PostMapping(AppRoutes.Money.POST_COMMITMENT)
    @Operation(summary = "Add financial commitment", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<FinancialCommitmentResponse>> addCommitment(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody FinancialCommitmentRequest request
    ) {
        try {
            Long userId = getUserId(userDetails);
            FinancialCommitmentResponse resp = moneyService.addCommitment(userId, request);
            log.success("MoneyProfile", "Added commitment '{}' for user {}", resp.getTitle(), userId);
            return ApiResponse.created("Commitment added successfully", resp);
        } catch (Exception ex) {
            log.error("MoneyProfile", "Failed to add commitment: {}", ex.getMessage());
            throw ex;
        }
    }

    @DeleteMapping(AppRoutes.Money.DELETE_COMMITMENT)
    @Operation(summary = "Delete financial commitment", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<Void>> deleteCommitment(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            moneyService.deleteCommitment(userId, id);
            log.success("MoneyProfile", "Deleted commitment {} for user {}", id, userId);
            return ApiResponse.ok("Commitment deleted successfully", null);
        } catch (Exception ex) {
            log.error("MoneyProfile", "Failed to delete commitment {}: {}", id, ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_SAVINGS_GOALS)
    @Operation(summary = "List savings goals", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<List<SavingsGoalResponse>>> getSavingsGoals(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            List<SavingsGoalResponse> resp = moneyService.getSavingsGoals(userId);
            return ApiResponse.ok("Savings goals retrieved successfully", resp);
        } catch (Exception ex) {
            log.error("MoneyProfile", "Failed to retrieve savings goals: {}", ex.getMessage());
            throw ex;
        }
    }

    @PostMapping(AppRoutes.Money.POST_SAVINGS_GOAL)
    @Operation(summary = "Add savings goal", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<SavingsGoalResponse>> addSavingsGoal(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody SavingsGoalRequest request
    ) {
        try {
            Long userId = getUserId(userDetails);
            SavingsGoalResponse resp = moneyService.addSavingsGoal(userId, request);
            log.success("MoneyProfile", "Added savings goal '{}' for user {}", resp.getTitle(), userId);
            return ApiResponse.created("Savings goal added successfully", resp);
        } catch (Exception ex) {
            log.error("MoneyProfile", "Failed to add savings goal: {}", ex.getMessage());
            throw ex;
        }
    }

    @DeleteMapping(AppRoutes.Money.DELETE_SAVINGS_GOAL)
    @Operation(summary = "Delete savings goal", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<Void>> deleteSavingsGoal(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            moneyService.deleteSavingsGoal(userId, id);
            log.success("MoneyProfile", "Deleted savings goal {} for user {}", id, userId);
            return ApiResponse.ok("Savings goal deleted successfully", null);
        } catch (Exception ex) {
            log.error("MoneyProfile", "Failed to delete savings goal {}: {}", id, ex.getMessage());
            throw ex;
        }
    }
}
