package com.lifeuse.auth.password.controller;

import com.lifeuse.AppRoutes;
import com.lifeuse.auth.password.models.ChangePasswordRequest;
import com.lifeuse.auth.password.models.ForgotPasswordRequest;
import com.lifeuse.auth.password.models.ResetPasswordRequest;
import com.lifeuse.auth.password.service.IPasswordResetService;
import com.lifeuse.common.ApiResponse;
import com.lifeuse.user.models.User;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "Auth — Password", description = "Forgot, reset, and change password workflows")
public class PasswordResetController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(PasswordResetController.class);

    private final IPasswordResetService passwordResetService;

    public PasswordResetController(IPasswordResetService passwordResetService) {
        this.passwordResetService = passwordResetService;
    }

    /**
     * POST /api/v1/auth/password/forgot -> PasswordResetController.forgotPassword()
     */
    @PostMapping(AppRoutes.Auth.POST_FORGOT_PASSWORD)
    @Operation(summary = "Initiate forgot password — sends reset link to email")
    public ResponseEntity<ApiResponse<Void>> forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        try {
            passwordResetService.initiateForgotPassword(request);
            log.info("Password", "Forgot-password initiated for email '{}'", request.getEmail());
            return ApiResponse.ok("If an account exists with the provided email, a password reset link has been dispatched.");
        } catch (Exception ex) {
            log.error("Password", "Forgot-password failed for email '{}': {}", request.getEmail(), ex.getMessage());
            throw ex;
        }
    }

    /**
     * POST /api/v1/auth/password/reset -> PasswordResetController.resetPassword()
     */
    @PostMapping(AppRoutes.Auth.POST_RESET_PASSWORD)
    @Operation(summary = "Reset password using token received via email")
    public ResponseEntity<ApiResponse<Void>> resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        try {
            passwordResetService.resetPassword(request);
            log.success("Password", "Password reset completed via token");
            return ApiResponse.ok("Password has been reset successfully. Please log in with your new credentials.");
        } catch (Exception ex) {
            log.error("Password", "Password reset failed: {}", ex.getMessage());
            throw ex;
        }
    }

    /**
     * POST /api/v1/auth/password/change -> PasswordResetController.changePassword()
     */
    @PostMapping(AppRoutes.Auth.POST_CHANGE_PASSWORD)
    @Operation(summary = "Change password for authenticated user")
    public ResponseEntity<ApiResponse<Void>> changePassword(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody ChangePasswordRequest request) {
        try {
            passwordResetService.changePassword(user, request);
            log.success("Password", "Password changed for user ID {}", user.getId());
            return ApiResponse.ok("Password has been updated successfully.");
        } catch (Exception ex) {
            log.error("Password", "Change password failed for user ID {}: {}", user != null ? user.getId() : "null", ex.getMessage());
            throw ex;
        }
    }
}
