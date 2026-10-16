package com.lifeuse.auth.register;

import com.lifeuse.auth.register.models.RegisterMapper;
import com.lifeuse.auth.register.models.RegisterRequest;
import com.lifeuse.auth.register.models.RegisterResponse;
import com.lifeuse.auth.register.repository.IRegisterRepository;
import com.lifeuse.auth.register.service.RegisterService;
import com.lifeuse.auth.verification.service.IVerificationService;
import com.lifeuse.common.BusinessException;
import com.lifeuse.common.DuplicateResourceException;
import com.lifeuse.user.models.Role;
import com.lifeuse.user.models.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.password.PasswordEncoder;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("RegisterService Unit Tests")
class RegisterServiceTest {

    @Mock
    private IRegisterRepository registerRepository;

    @Mock
    private RegisterMapper registerMapper;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private IVerificationService verificationService;

    @InjectMocks
    private RegisterService registerService;

    private RegisterRequest validRequest;
    private User testUser;
    private RegisterResponse expectedResponse;

    @BeforeEach
    void setUp() {
        validRequest = new RegisterRequest(
                "janedoe", "Jane", "Doe", "jane@example.com", "+1234567890", "Password123!", "Password123!"
        );

        testUser = new User("janedoe", "Jane", "Doe", "jane@example.com", "+1234567890", "encodedPassword", Role.ROLE_USER);
        testUser.setId(1L);

        expectedResponse = new RegisterResponse(1L, "janedoe", "jane@example.com", "+1234567890", false, false);
    }

    @Test
    @DisplayName("Should successfully register a new user")
    void shouldRegisterUserSuccessfully() {
        when(registerRepository.existsByEmail("jane@example.com")).thenReturn(false);
        when(registerRepository.existsByUsername("janedoe")).thenReturn(false);
        when(registerRepository.existsByPhoneNumber("+1234567890")).thenReturn(false);
        when(passwordEncoder.encode("Password123!")).thenReturn("encodedPassword");
        when(registerMapper.toEntity(validRequest, "encodedPassword")).thenReturn(testUser);
        when(registerRepository.save(testUser)).thenReturn(testUser);
        when(registerMapper.toResponse(testUser)).thenReturn(expectedResponse);

        RegisterResponse response = registerService.register(validRequest);

        assertNotNull(response);
        assertEquals(1L, response.getId());
        assertEquals("janedoe", response.getUsername());
        verify(verificationService).sendEmailVerificationOtp(testUser);
        verify(verificationService).sendPhoneVerificationOtp(testUser);
    }

    @Test
    @DisplayName("Should throw BusinessException when passwords do not match")
    void shouldThrowWhenPasswordsDoNotMatch() {
        validRequest.setConfirmPassword("mismatched_password");

        assertThrows(BusinessException.class, () -> registerService.register(validRequest));
        verify(registerRepository, never()).save(any());
    }

    @Test
    @DisplayName("Should throw DuplicateResourceException when email already exists")
    void shouldThrowWhenEmailExists() {
        when(registerRepository.existsByEmail("jane@example.com")).thenReturn(true);

        assertThrows(DuplicateResourceException.class, () -> registerService.register(validRequest));
        verify(registerRepository, never()).save(any());
    }

    @Test
    @DisplayName("Should throw DuplicateResourceException when username already exists")
    void shouldThrowWhenUsernameExists() {
        when(registerRepository.existsByEmail("jane@example.com")).thenReturn(false);
        when(registerRepository.existsByUsername("janedoe")).thenReturn(true);

        assertThrows(DuplicateResourceException.class, () -> registerService.register(validRequest));
        verify(registerRepository, never()).save(any());
    }

    @Test
    @DisplayName("Should throw DuplicateResourceException when phone number already exists")
    void shouldThrowWhenPhoneExists() {
        when(registerRepository.existsByEmail("jane@example.com")).thenReturn(false);
        when(registerRepository.existsByUsername("janedoe")).thenReturn(false);
        when(registerRepository.existsByPhoneNumber("+1234567890")).thenReturn(true);

        assertThrows(DuplicateResourceException.class, () -> registerService.register(validRequest));
        verify(registerRepository, never()).save(any());
    }

    @Test
    @DisplayName("Should handle database unique constraint violation gracefully")
    void shouldHandleDatabaseUniqueConstraintViolation() {
        when(registerRepository.existsByEmail(any())).thenReturn(false);
        when(registerRepository.existsByUsername(any())).thenReturn(false);
        when(registerRepository.existsByPhoneNumber(any())).thenReturn(false);
        when(passwordEncoder.encode(any())).thenReturn("encodedPassword");
        when(registerMapper.toEntity(any(), any())).thenReturn(testUser);
        when(registerRepository.save(any())).thenThrow(new DataIntegrityViolationException("duplicate key"));

        assertThrows(DuplicateResourceException.class, () -> registerService.register(validRequest));
    }
}
