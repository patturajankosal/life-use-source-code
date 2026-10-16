package com.lifeuse.auth.verification.controller;

import com.lifeuse.AppRoutes;
import com.lifeuse.auth.verification.models.EmailVerificationRequest;
import com.lifeuse.auth.verification.models.PhoneVerificationRequest;
import com.lifeuse.auth.verification.models.ResendOtpRequest;
import com.lifeuse.auth.verification.models.VerificationResponse;
import com.lifeuse.auth.verification.service.IVerificationService;
import com.lifeuse.common.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "Auth — Verification", description = "OTP verification for email and phone")
public class VerificationController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(VerificationController.class);

    private final IVerificationService verificationService;

    public VerificationController(IVerificationService verificationService) {
        this.verificationService = verificationService;
    }

    /**
     * POST /api/v1/auth/verify/email -> VerificationController.verifyEmail()
     */
    @PostMapping(AppRoutes.Auth.POST_VERIFY_EMAIL)
    @Operation(summary = "Verify email address via OTP code")
    public ResponseEntity<ApiResponse<VerificationResponse>> verifyEmail(@Valid @RequestBody EmailVerificationRequest request) {
        try {
            VerificationResponse response = verificationService.verifyEmail(request);
            log.success("Verification", "Email verified for '{}'", request.getEmail());
            return ApiResponse.ok("Email verified successfully", response);
        } catch (Exception ex) {
            log.error("Verification", "Email verification failed for '{}': {}", request.getEmail(), ex.getMessage());
            throw ex;
        }
    }

    /**
     * POST /api/v1/auth/verify/phone -> VerificationController.verifyPhone()
     */
    @PostMapping(AppRoutes.Auth.POST_VERIFY_PHONE)
    @Operation(summary = "Verify phone number via OTP code")
    public ResponseEntity<ApiResponse<VerificationResponse>> verifyPhone(@Valid @RequestBody PhoneVerificationRequest request) {
        try {
            VerificationResponse response = verificationService.verifyPhone(request);
            log.success("Verification", "Phone verified for '{}'", request.getPhoneNumber());
            return ApiResponse.ok("Phone verified successfully", response);
        } catch (Exception ex) {
            log.error("Verification", "Phone verification failed for '{}': {}", request.getPhoneNumber(), ex.getMessage());
            throw ex;
        }
    }

    /**
     * POST /api/v1/auth/verify/resend -> VerificationController.resendOtp()
     */
    @PostMapping(AppRoutes.Auth.POST_RESEND_OTP)
    @Operation(summary = "Resend OTP code to email or phone")
    public ResponseEntity<ApiResponse<VerificationResponse>> resendOtp(@Valid @RequestBody ResendOtpRequest request) {
        try {
            VerificationResponse response = verificationService.resendOtp(request);
            log.info("Verification", "OTP resent for identifier '{}'", request.getIdentifier());
            return ApiResponse.ok("Verification code resent successfully", response);
        } catch (Exception ex) {
            log.error("Verification", "Resend OTP failed for identifier '{}': {}", request.getIdentifier(), ex.getMessage());
            throw ex;
        }
    }
}
