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

    public PasswordResetService(IUserRepository userRepository,
                                IPasswordResetRepository passwordResetTokenRepository,
                                PasswordEncoder passwordEncoder,
                                IEmailService emailService,
                                ITokenService tokenService) {
        this.userRepository = userRepository;
        this.passwordResetTokenRepository = passwordResetTokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.emailService = emailService;
        this.tokenService = tokenService;
    }

    @Override
    @Transactional
    public void initiateForgotPassword(ForgotPasswordRequest request) {
        String email = request.getEmail().trim().toLowerCase();
        User user = userRepository.findByEmail(email).orElse(null);

        if (user == null) {
            log.info("Password reset requested for non-existent email: {}", email);
            return;
        }

        String resetToken = UUID.randomUUID().toString();
        Instant expiresAt = Instant.now().plus(RESET_TOKEN_EXPIRATION_MINUTES, ChronoUnit.MINUTES);

        PasswordResetToken tokenEntity = new PasswordResetToken(user, resetToken, expiresAt);
        passwordResetTokenRepository.save(tokenEntity);

        emailService.sendPasswordResetEmail(user.getEmail(), resetToken);
        log.info("Password reset token generated and sent for user ID: {}", user.getId());
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
