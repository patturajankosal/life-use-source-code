package com.lifeuse.auth.verification;

import com.lifeuse.auth.verification.models.EmailVerificationRequest;
import com.lifeuse.auth.verification.models.OtpType;
import com.lifeuse.auth.verification.models.OtpVerification;
import com.lifeuse.auth.verification.models.VerificationResponse;
import com.lifeuse.auth.verification.repository.IVerificationRepository;
import com.lifeuse.auth.verification.service.VerificationService;
import com.lifeuse.common.BusinessException;
import com.lifeuse.notification.IEmailService;
import com.lifeuse.notification.ISmsService;
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
import org.springframework.test.util.ReflectionTestUtils;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("VerificationService Unit Tests")
class VerificationServiceTest {

    @Mock
    private IVerificationRepository otpRepository;

    @Mock
    private IUserRepository userRepository;

    @Mock
    private IEmailService emailService;

    @Mock
    private ISmsService smsService;

    @InjectMocks
    private VerificationService verificationService;

    private User testUser;
    private OtpVerification activeOtp;

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(verificationService, "otpExpirationMinutes", 10);
        ReflectionTestUtils.setField(verificationService, "maxAttempts", 5);

        testUser = new User("alice", "Alice", "Smith", "alice@example.com", "+1234567890", "encodedPwd", Role.ROLE_USER);
        testUser.setId(1L);
        testUser.setEmailVerified(false);

        activeOtp = new OtpVerification(testUser, "123456", OtpType.EMAIL, Instant.now().plus(10, ChronoUnit.MINUTES));
    }

    @Test
    @DisplayName("Should successfully verify email with valid OTP")
    void shouldVerifyEmailSuccessfully() {
        EmailVerificationRequest request = new EmailVerificationRequest("alice@example.com", "123456");

        when(userRepository.findByEmail("alice@example.com")).thenReturn(Optional.of(testUser));
        when(otpRepository.findTopByUserAndTypeAndVerifiedFalseOrderByCreatedAtDesc(testUser, OtpType.EMAIL))
                .thenReturn(Optional.of(activeOtp));

        VerificationResponse response = verificationService.verifyEmail(request);

        assertNotNull(response);
        assertTrue(response.isVerified());
        assertTrue(testUser.isEmailVerified());
        assertTrue(activeOtp.isVerified());
        verify(userRepository).save(testUser);
        verify(otpRepository).save(activeOtp);
    }

    @Test
    @DisplayName("Should reject verification with incorrect OTP")
    void shouldRejectIncorrectOtp() {
        EmailVerificationRequest request = new EmailVerificationRequest("alice@example.com", "999999");

        when(userRepository.findByEmail("alice@example.com")).thenReturn(Optional.of(testUser));
        when(otpRepository.findTopByUserAndTypeAndVerifiedFalseOrderByCreatedAtDesc(testUser, OtpType.EMAIL))
                .thenReturn(Optional.of(activeOtp));

        assertThrows(BusinessException.class, () -> verificationService.verifyEmail(request));
        assertFalse(testUser.isEmailVerified());
        assertEquals(1, activeOtp.getAttempts());
    }

    @Test
    @DisplayName("Should reject verification when OTP has expired")
    void shouldRejectExpiredOtp() {
        activeOtp.setExpiresAt(Instant.now().minus(1, ChronoUnit.MINUTES));
        EmailVerificationRequest request = new EmailVerificationRequest("alice@example.com", "123456");

        when(userRepository.findByEmail("alice@example.com")).thenReturn(Optional.of(testUser));
        when(otpRepository.findTopByUserAndTypeAndVerifiedFalseOrderByCreatedAtDesc(testUser, OtpType.EMAIL))
                .thenReturn(Optional.of(activeOtp));

        assertThrows(BusinessException.class, () -> verificationService.verifyEmail(request));
    }
}
