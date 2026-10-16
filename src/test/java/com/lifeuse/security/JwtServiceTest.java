package com.lifeuse.security;

import com.lifeuse.user.models.Role;
import com.lifeuse.user.models.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("JwtService Unit Tests")
class JwtServiceTest {

    private JwtService jwtService;
    private User testUser;

    @BeforeEach
    void setUp() {
        jwtService = new JwtService();
        // 256-bit base64 secret
        ReflectionTestUtils.setField(jwtService, "secretKey", "404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970");
        ReflectionTestUtils.setField(jwtService, "jwtExpirationMs", 900000L);
        ReflectionTestUtils.setField(jwtService, "refreshExpirationMs", 604800000L);

        testUser = new User("alice", "Alice", "Smith", "alice@example.com", "+1987654321", "hashedPwd", Role.ROLE_USER);
        testUser.setId(100L);
    }

    @Test
    @DisplayName("Should generate valid JWT token with user claims")
    void shouldGenerateValidToken() {
        String token = jwtService.generateToken(testUser);

        assertNotNull(token);
        assertTrue(token.length() > 20);

        String username = jwtService.extractUsername(token);
        assertEquals("alice", username);

        Long userId = jwtService.extractUserId(token);
        assertEquals(100L, userId);

        assertTrue(jwtService.isTokenValid(token, testUser));
        assertTrue(jwtService.validateToken(token));
    }

    @Test
    @DisplayName("Should generate valid refresh token")
    void shouldGenerateRefreshToken() {
        String refreshToken = jwtService.generateRefreshToken(testUser);

        assertNotNull(refreshToken);
        String username = jwtService.extractUsername(refreshToken);
        assertEquals("alice", username);
        assertTrue(jwtService.validateToken(refreshToken));
    }

    @Test
    @DisplayName("Should reject token for different user details")
    void shouldRejectTokenForMismatchedUser() {
        String token = jwtService.generateToken(testUser);

        User anotherUser = new User("bob", "Bob", "Brown", "bob@example.com", "+1122334455", "pwd", Role.ROLE_USER);
        assertFalse(jwtService.isTokenValid(token, anotherUser));
    }

    @Test
    @DisplayName("Should reject invalid token string")
    void shouldRejectInvalidToken() {
        assertFalse(jwtService.validateToken("invalid.token.structure"));
    }
}
