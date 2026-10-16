package com.lifeuse.auth.password;

import com.lifeuse.auth.password.models.ForgotPasswordRequest;
import com.lifeuse.auth.password.models.PasswordResetToken;
import com.lifeuse.auth.password.models.ResetPasswordRequest;
import com.lifeuse.auth.password.repository.IPasswordResetRepository;
import com.lifeuse.auth.password.service.PasswordResetService;
import com.lifeuse.auth.token.service.ITokenService;
import com.lifeuse.common.BusinessException;
import com.lifeuse.notification.IEmailService;
import com.lifeuse.user.models.Role;
import com.lifeuse.user.models.User;
import com.lifeuse.user.repository.IUserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("PasswordResetService Unit Tests")
class PasswordResetServiceTest {

    @Mock
    private IUserRepository userRepository;

    @Mock
    private IPasswordResetRepository passwordResetTokenRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private IEmailService emailService;

    @Mock
    private ITokenService tokenService;

    @InjectMocks
    private PasswordResetService passwordResetService;

    private User testUser;
    private PasswordResetToken validToken;

    @BeforeEach
    void setUp() {
        testUser = new User("bob_builder", "Bob", "Builder", "bob@example.com", "+1234567890", "oldEncodedPassword", Role.ROLE_USER);
        testUser.setId(20L);

        validToken = new PasswordResetToken(testUser, "validResetToken123", Instant.now().plus(15, ChronoUnit.MINUTES));
    }

    @Test
    @DisplayName("Should initiate forgot password by generating token and sending email")
    void shouldInitiateForgotPassword() {
        ForgotPasswordRequest request = new ForgotPasswordRequest("bob@example.com");
        when(userRepository.findByEmail("bob@example.com")).thenReturn(Optional.of(testUser));

        passwordResetService.initiateForgotPassword(request);

        verify(passwordResetTokenRepository).save(any(PasswordResetToken.class));
        verify(emailService).sendPasswordResetEmail(eq("bob@example.com"), anyString());
    }

    @Test
    @DisplayName("Should successfully reset password with valid token and revoke active sessions")
    void shouldResetPasswordSuccessfully() {
        ResetPasswordRequest request = new ResetPasswordRequest("validResetToken123", "newSecretPassword");

        when(passwordResetTokenRepository.findByToken("validResetToken123")).thenReturn(Optional.of(validToken));
        when(passwordEncoder.encode("newSecretPassword")).thenReturn("newEncodedHash");

        passwordResetService.resetPassword(request);

        assertEquals("newEncodedHash", testUser.getPassword());
        assertTrue(validToken.isUsed());
        verify(userRepository).save(testUser);
        verify(passwordResetTokenRepository).save(validToken);
        verify(tokenService).revokeUserTokens(testUser);
    }

    @Test
    @DisplayName("Should throw BusinessException when reset token already used")
    void shouldRejectUsedToken() {
        validToken.setUsed(true);
        ResetPasswordRequest request = new ResetPasswordRequest("validResetToken123", "newSecretPassword");

        when(passwordResetTokenRepository.findByToken("validResetToken123")).thenReturn(Optional.of(validToken));

        assertThrows(BusinessException.class, () -> passwordResetService.resetPassword(request));
        verify(userRepository, never()).save(any());
    }

    @Test
    @DisplayName("Should throw BusinessException when reset token expired")
    void shouldRejectExpiredToken() {
        validToken.setExpiresAt(Instant.now().minus(5, ChronoUnit.MINUTES));
        ResetPasswordRequest request = new ResetPasswordRequest("validResetToken123", "newSecretPassword");

        when(passwordResetTokenRepository.findByToken("validResetToken123")).thenReturn(Optional.of(validToken));

        assertThrows(BusinessException.class, () -> passwordResetService.resetPassword(request));
        verify(userRepository, never()).save(any());
    }
}
