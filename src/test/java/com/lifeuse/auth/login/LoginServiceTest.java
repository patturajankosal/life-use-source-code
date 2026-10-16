package com.lifeuse.auth.login;

import com.lifeuse.auth.login.models.LoginMapper;
import com.lifeuse.auth.login.models.LoginRequest;
import com.lifeuse.auth.login.models.LoginResponse;
import com.lifeuse.auth.login.repository.ILoginRepository;
import com.lifeuse.auth.login.service.LoginService;
import com.lifeuse.auth.token.models.RefreshToken;
import com.lifeuse.auth.token.service.ITokenService;
import com.lifeuse.security.JwtService;
import com.lifeuse.user.models.Role;
import com.lifeuse.user.models.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;

import java.time.Instant;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("LoginService Unit Tests")
class LoginServiceTest {

    @Mock
    private AuthenticationManager authenticationManager;

    @Mock
    private ILoginRepository loginRepository;

    @Mock
    private JwtService jwtService;

    @Mock
    private ITokenService tokenService;

    @Mock
    private LoginMapper loginMapper;

    @InjectMocks
    private LoginService loginService;

    private User testUser;
    private RefreshToken refreshToken;
    private LoginResponse expectedResponse;

    @BeforeEach
    void setUp() {
        testUser = new User("user_one", "User", "One", "user@example.com", "+1234567890", "encoded", Role.ROLE_USER);
        testUser.setId(10L);

        refreshToken = new RefreshToken(testUser, "sampleRefreshToken", Instant.now().plusSeconds(3600));
        expectedResponse = new LoginResponse("sampleAccessToken", "sampleRefreshToken", "Bearer", 900, 10L, "user_one", "user@example.com", "User", "One", "+1234567890", "ROLE_USER", true, true);
    }

    @Test
    @DisplayName("Should successfully authenticate using email identifier")
    void shouldLoginSuccessfullyWithEmail() {
        LoginRequest request = new LoginRequest("user@example.com", "password123");
        Authentication auth = mock(Authentication.class);
        when(auth.getPrincipal()).thenReturn(testUser);
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class))).thenReturn(auth);
        when(jwtService.generateToken(testUser)).thenReturn("sampleAccessToken");
        when(tokenService.createRefreshToken(testUser)).thenReturn(refreshToken);
        when(jwtService.getJwtExpirationMs()).thenReturn(900000L);
        when(loginMapper.toResponse(testUser, "sampleAccessToken", "sampleRefreshToken", 900L)).thenReturn(expectedResponse);

        LoginResponse response = loginService.login(request);

        assertNotNull(response);
        assertEquals("sampleAccessToken", response.getAccessToken());
        assertEquals("sampleRefreshToken", response.getRefreshToken());
        assertEquals("user@example.com", response.getEmail());
        assertEquals("user_one", response.getUsername());
    }

    @Test
    @DisplayName("Should successfully authenticate using username identifier")
    void shouldLoginSuccessfullyWithUsername() {
        LoginRequest request = new LoginRequest("user_one", "password123");
        Authentication auth = mock(Authentication.class);
        when(auth.getPrincipal()).thenReturn(testUser);
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class))).thenReturn(auth);
        when(jwtService.generateToken(testUser)).thenReturn("sampleAccessToken");
        when(tokenService.createRefreshToken(testUser)).thenReturn(refreshToken);
        when(jwtService.getJwtExpirationMs()).thenReturn(900000L);
        when(loginMapper.toResponse(testUser, "sampleAccessToken", "sampleRefreshToken", 900L)).thenReturn(expectedResponse);

        LoginResponse response = loginService.login(request);

        assertNotNull(response);
        assertEquals("user_one", response.getUsername());
    }

    @Test
    @DisplayName("Should successfully authenticate using phone number identifier")
    void shouldLoginSuccessfullyWithPhoneNumber() {
        LoginRequest request = new LoginRequest("+1234567890", "password123");
        Authentication auth = mock(Authentication.class);
        when(auth.getPrincipal()).thenReturn(testUser);
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class))).thenReturn(auth);
        when(jwtService.generateToken(testUser)).thenReturn("sampleAccessToken");
        when(tokenService.createRefreshToken(testUser)).thenReturn(refreshToken);
        when(jwtService.getJwtExpirationMs()).thenReturn(900000L);
        when(loginMapper.toResponse(testUser, "sampleAccessToken", "sampleRefreshToken", 900L)).thenReturn(expectedResponse);

        LoginResponse response = loginService.login(request);

        assertNotNull(response);
        assertEquals("+1234567890", response.getPhoneNumber());
    }

    @Test
    @DisplayName("Should propagate BadCredentialsException on invalid credentials")
    void shouldThrowBadCredentialsOnInvalidPassword() {
        LoginRequest request = new LoginRequest("user@example.com", "wrongpassword");
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                .thenThrow(new BadCredentialsException("Bad credentials"));

        assertThrows(BadCredentialsException.class, () -> loginService.login(request));
    }

    @Test
    @DisplayName("Should reject blank login identifier")
    void shouldThrowOnBlankIdentifier() {
        LoginRequest request = new LoginRequest("", "password123");
        assertThrows(BadCredentialsException.class, () -> loginService.login(request));
    }
}
