package com.lifeuse.auth.login;

import com.lifeuse.auth.login.models.LoginMapper;
import com.lifeuse.auth.login.models.LoginResponse;
import com.lifeuse.user.models.Role;
import com.lifeuse.user.models.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("LoginMapper Unit Tests")
class LoginMapperTest {

    private LoginMapper loginMapper;

    @BeforeEach
    void setUp() {
        loginMapper = new LoginMapper();
    }

    @Test
    @DisplayName("Should map User entity correctly to LoginResponse DTO")
    void shouldMapUserToLoginResponse() {
        User user = new User("sarah_connor", "Sarah", "Connor", "sarah@example.com", "+1098765432", "pwd", Role.ROLE_USER);
        user.setId(5L);
        user.setEmailVerified(true);
        user.setPhoneVerified(true);

        LoginResponse response = loginMapper.toResponse(user, "accessToken123", "refreshToken123", 900L);

        assertNotNull(response);
        assertEquals("accessToken123", response.getAccessToken());
        assertEquals("refreshToken123", response.getRefreshToken());
        assertEquals(900L, response.getExpiresIn());
        assertEquals(5L, response.getUserId());
        assertEquals("sarah_connor", response.getUsername());
        assertEquals("sarah@example.com", response.getEmail());
        assertEquals("Sarah", response.getFirstName());
        assertEquals("Connor", response.getLastName());
        assertEquals("+1098765432", response.getPhoneNumber());
        assertEquals("ROLE_USER", response.getRole());
        assertTrue(response.isEmailVerified());
        assertTrue(response.isPhoneVerified());
    }

    @Test
    @DisplayName("Should return null when user is null")
    void shouldReturnNullWhenUserIsNull() {
        assertNull(loginMapper.toResponse(null, "access", "refresh", 900L));
    }
}
