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
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.List;

@RestController
@Tag(name = "Money Transactions", description = "Transaction tracking and category endpoints")
public class TransactionController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(TransactionController.class);

    private final IMoneyService moneyService;
    private final IUserService userService;

    public TransactionController(IMoneyService moneyService, IUserService userService) {
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

    @GetMapping(AppRoutes.Money.GET_TRANSACTIONS)
    @Operation(summary = "List transactions with filters and pagination", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<List<TransactionResponse>>> getTransactions(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant toDate,
            @RequestParam(defaultValue = "50") int limit,
            @RequestParam(defaultValue = "0") int offset
    ) {
        try {
            Long userId = getUserId(userDetails);
            List<TransactionResponse> list = moneyService.getTransactions(userId, type, category, fromDate, toDate, limit, offset);
            return ApiResponse.ok("Transactions retrieved successfully", list);
        } catch (Exception ex) {
            log.error("Transaction", "Failed to retrieve transactions: {}", ex.getMessage());
            throw ex;
        }
    }

    @PostMapping(AppRoutes.Money.POST_TRANSACTION)
    @Operation(summary = "Record a new financial transaction (idempotent)", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<TransactionResponse>> createTransaction(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody TransactionCreateRequest request
    ) {
        try {
            Long userId = getUserId(userDetails);
            TransactionResponse resp = moneyService.createTransaction(userId, request);
            log.success("Transaction", "Recorded {} transaction of ₹{} for user {}", resp.getTransactionType(), resp.getAmount(), userId);
            return ApiResponse.created("Transaction recorded successfully", resp);
        } catch (Exception ex) {
            log.error("Transaction", "Failed to record transaction: {}", ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_TRANSACTION_BY_ID)
    @Operation(summary = "Get transaction details by ID", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<TransactionResponse>> getTransactionById(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            TransactionResponse resp = moneyService.getTransactionById(userId, id);
            return ApiResponse.ok("Transaction retrieved successfully", resp);
        } catch (Exception ex) {
            log.error("Transaction", "Failed to retrieve transaction {}: {}", id, ex.getMessage());
            throw ex;
        }
    }

    @DeleteMapping(AppRoutes.Money.DELETE_TRANSACTION)
    @Operation(summary = "Delete transaction by ID", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<Void>> deleteTransaction(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id
    ) {
        try {
            Long userId = getUserId(userDetails);
            moneyService.deleteTransaction(userId, id);
            log.success("Transaction", "Deleted transaction {} for user {}", id, userId);
            return ApiResponse.ok("Transaction deleted successfully", null);
        } catch (Exception ex) {
            log.error("Transaction", "Failed to delete transaction {}: {}", id, ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_TRANSACTION_SUMMARY)
    @Operation(summary = "Get transaction summary metrics for a date range", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<TransactionSummaryResponse>> getTransactionSummary(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant toDate
    ) {
        try {
            Long userId = getUserId(userDetails);
            TransactionSummaryResponse resp = moneyService.getTransactionSummary(userId, fromDate, toDate);
            return ApiResponse.ok("Transaction summary retrieved successfully", resp);
        } catch (Exception ex) {
            log.error("Transaction", "Failed to retrieve transaction summary: {}", ex.getMessage());
            throw ex;
        }
    }

    @GetMapping(AppRoutes.Money.GET_CATEGORIES)
    @Operation(summary = "List all expense categories", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> getCategories(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = getUserId(userDetails);
            List<CategoryResponse> list = moneyService.getCategories(userId);
            return ApiResponse.ok("Categories retrieved successfully", list);
        } catch (Exception ex) {
            log.error("Transaction", "Failed to retrieve categories: {}", ex.getMessage());
            throw ex;
        }
    }

    @PostMapping(AppRoutes.Money.POST_CATEGORY)
    @Operation(summary = "Create custom expense category", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<CategoryResponse>> createCategory(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody CategoryRequest request
    ) {
        try {
            Long userId = getUserId(userDetails);
            CategoryResponse resp = moneyService.createCategory(userId, request);
            log.success("Transaction", "Created category '{}' for user {}", resp.getName(), userId);
            return ApiResponse.created("Category created successfully", resp);
        } catch (Exception ex) {
            log.error("Transaction", "Failed to create category: {}", ex.getMessage());
            throw ex;
        }
    }
}
