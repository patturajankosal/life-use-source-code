package com.lifeuse.auth.password.service;

import com.lifeuse.auth.password.models.ChangePasswordRequest;
import com.lifeuse.auth.password.models.ForgotPasswordRequest;
import com.lifeuse.auth.password.models.PasswordResetToken;
import com.lifeuse.auth.password.models.ResetPasswordRequest;
import com.lifeuse.auth.password.repository.IPasswordResetRepository;
import com.lifeuse.auth.token.service.ITokenService;
import com.lifeuse.common.BusinessException;
import com.lifeuse.common.ResourceNotFoundException;
import com.lifeuse.notification.IEmailService;
import com.lifeuse.user.models.User;
import com.lifeuse.user.repository.IUserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

@Service
public class PasswordResetService implements IPasswordResetService {

    private static final Logger log = LoggerFactory.getLogger(PasswordResetService.class);
    private static final int RESET_TOKEN_EXPIRATION_MINUTES = 15;

    private final IUserRepository userRepository;
    private final IPasswordResetRepository passwordResetTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final IEmailService emailService;
    private final ITokenService tokenService;
    private final com.lifeuse.auth.verification.repository.IVerificationRepository otpRepository;
    private final com.lifeuse.notification.delivery.IOtpDeliveryService otpDeliveryService;

    public PasswordResetService(IUserRepository userRepository,
                                IPasswordResetRepository passwordResetTokenRepository,
                                PasswordEncoder passwordEncoder,
                                IEmailService emailService,
                                ITokenService tokenService,
                                com.lifeuse.auth.verification.repository.IVerificationRepository otpRepository,
                                com.lifeuse.notification.delivery.IOtpDeliveryService otpDeliveryService) {
        this.userRepository = userRepository;
        this.passwordResetTokenRepository = passwordResetTokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.emailService = emailService;
        this.tokenService = tokenService;
        this.otpRepository = otpRepository;
        this.otpDeliveryService = otpDeliveryService;
    }

    @Override
    @Transactional
    public void initiateForgotPassword(ForgotPasswordRequest request) {
        String identifier = request.getIdentifier() != null ? request.getIdentifier().trim() : request.getEmail().trim();
        User user = userRepository.findByLoginIdentifier(identifier).orElse(null);

        if (user == null) {
            log.info("Password reset requested for non-existent identifier: {}", identifier);
            return;
        }

        boolean isEmail = identifier.contains("@") || (user.getEmail() != null && user.getEmail().equalsIgnoreCase(identifier));
        com.lifeuse.auth.verification.models.OtpType otpType = isEmail
                ? com.lifeuse.auth.verification.models.OtpType.EMAIL
                : com.lifeuse.auth.verification.models.OtpType.PHONE;
        String destination = isEmail
                ? (user.getEmail() != null ? user.getEmail() : identifier)
                : (user.getPhoneNumber() != null ? user.getPhoneNumber() : identifier);

        String otpCode = com.lifeuse.common.OtpGenerator.generateOtp();
        Instant expiresAt = Instant.now().plus(10, ChronoUnit.MINUTES);

        com.lifeuse.auth.verification.models.OtpVerification otp =
                new com.lifeuse.auth.verification.models.OtpVerification(user, destination, otpCode, otpType, expiresAt);
        otpRepository.save(otp);

        otpDeliveryService.deliverOtp(destination, otpType, otpCode, "Password Reset");

        // Backward compatibility: also generate reset token and trigger email service if email
        if (isEmail && user.getEmail() != null) {
            String resetToken = UUID.randomUUID().toString();
            Instant resetExpiresAt = Instant.now().plus(RESET_TOKEN_EXPIRATION_MINUTES, ChronoUnit.MINUTES);
            PasswordResetToken tokenEntity = new PasswordResetToken(user, resetToken, resetExpiresAt);
            passwordResetTokenRepository.save(tokenEntity);
            emailService.sendPasswordResetEmail(user.getEmail(), resetToken);
        }
        log.info("Password reset OTP dispatched for user ID: {}", user.getId());
    }

    @Override
    @Transactional
    public String verifyForgotPasswordOtp(String identifier, String otpCode) {
        if (identifier == null || identifier.isBlank() || otpCode == null || otpCode.isBlank()) {
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.VALIDATION_FAILED, "Identifier and OTP code are required");
        }

        String trimmed = identifier.trim();
        User user = userRepository.findByLoginIdentifier(trimmed)
                .orElseThrow(() -> new ResourceNotFoundException("User", "identifier", trimmed));

        boolean isEmail = trimmed.contains("@") || (user.getEmail() != null && user.getEmail().equalsIgnoreCase(trimmed));
        com.lifeuse.auth.verification.models.OtpType otpType = isEmail
                ? com.lifeuse.auth.verification.models.OtpType.EMAIL
                : com.lifeuse.auth.verification.models.OtpType.PHONE;

        com.lifeuse.auth.verification.models.OtpVerification otp = otpRepository
                .findTopByUserAndTypeAndVerifiedFalseOrderByCreatedAtDesc(user, otpType)
                .orElseGet(() -> otpRepository.findTopByIdentifierAndTypeAndVerifiedFalseOrderByCreatedAtDesc(trimmed, otpType)
                        .orElseThrow(() -> new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.RESOURCE_NOT_FOUND, "No active password reset verification code found. Please request a new one.")));

        if (Instant.now().isAfter(otp.getExpiresAt())) {
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.TOKEN_EXPIRED, "Verification code has expired. Please request a new one.");
        }

        if (otp.getAttempts() >= 5) {
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.BAD_REQUEST, "Maximum verification attempts exceeded. Please request a new code.");
        }

        otp.setAttempts(otp.getAttempts() + 1);

        if (!otp.getOtpCode().equals(otpCode.trim())) {
            otpRepository.save(otp);
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.VALIDATION_FAILED, "Invalid verification code");
        }

        otp.setVerified(true);
        otpRepository.save(otp);

        String resetToken = UUID.randomUUID().toString();
        Instant expiresAt = Instant.now().plus(RESET_TOKEN_EXPIRATION_MINUTES, ChronoUnit.MINUTES);
        PasswordResetToken tokenEntity = new PasswordResetToken(user, resetToken, expiresAt);
        passwordResetTokenRepository.save(tokenEntity);

        return resetToken;
    }

    @Override
    @Transactional
    public void resetPassword(ResetPasswordRequest request) {
        String token = request.getToken().trim();

        PasswordResetToken tokenEntity = passwordResetTokenRepository.findByToken(token)
                .orElseThrow(() -> new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.RESOURCE_NOT_FOUND, "Invalid or non-existent password reset token"));

        if (tokenEntity.isUsed()) {
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.BAD_REQUEST, "Password reset token has already been used");
        }

        if (tokenEntity.getExpiresAt().isBefore(Instant.now())) {
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.TOKEN_EXPIRED, "Password reset token has expired. Please request a new one.");
        }

        User user = tokenEntity.getUser();
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);

        tokenEntity.setUsed(true);
        passwordResetTokenRepository.save(tokenEntity);

        // Security best practice: revoke all existing active refresh tokens
        tokenService.revokeUserTokens(user);
        log.info("Password successfully reset for user ID: {}", user.getId());
    }

    @Override
    @Transactional
    public void changePassword(User user, ChangePasswordRequest request) {
        User existingUser = userRepository.findById(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", user.getId()));

        if (!passwordEncoder.matches(request.getCurrentPassword(), existingUser.getPassword())) {
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.INVALID_CREDENTIALS, "Current password does not match");
        }

        existingUser.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(existingUser);

        tokenService.revokeUserTokens(existingUser);
        log.info("Password changed successfully for user ID: {}", existingUser.getId());
    }
}
