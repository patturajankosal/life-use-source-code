package com.lifeuse.auth.register;

import com.lifeuse.auth.register.models.RegisterMapper;
import com.lifeuse.auth.register.models.RegisterRequest;
import com.lifeuse.auth.register.models.RegisterResponse;
import com.lifeuse.user.models.Role;
import com.lifeuse.user.models.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("RegisterMapper Unit Tests")
class RegisterMapperTest {

    private RegisterMapper registerMapper;

    @BeforeEach
    void setUp() {
        registerMapper = new RegisterMapper();
    }

    @Test
    @DisplayName("Should map RegisterRequest correctly to User entity")
    void shouldMapRequestToEntity() {
        RegisterRequest request = new RegisterRequest(
                "john_doe", "John", "Doe", "john@example.com", "+1234567890", "Secret123!", "Secret123!"
        );

        User user = registerMapper.toEntity(request, "encodedPasswordHash");

        assertNotNull(user);
        assertEquals("john_doe", user.getUsername());
        assertEquals("John", user.getFirstName());
        assertEquals("Doe", user.getLastName());
        assertEquals("john@example.com", user.getEmail());
        assertEquals("+1234567890", user.getPhoneNumber());
        assertEquals("encodedPasswordHash", user.getPassword());
        assertEquals(Role.ROLE_USER, user.getRole());
        assertFalse(user.isEmailVerified());
        assertFalse(user.isPhoneVerified());
        assertTrue(user.isEnabled());
    }

    @Test
    @DisplayName("Should map User entity correctly to RegisterResponse DTO")
    void shouldMapEntityToResponse() {
        User user = new User("jane_smith", "Jane", "Smith", "jane@example.com", "+1987654321", "pwd", Role.ROLE_USER);
        user.setId(42L);
        user.setEmailVerified(false);
        user.setPhoneVerified(false);

        RegisterResponse response = registerMapper.toResponse(user);

        assertNotNull(response);
        assertEquals(42L, response.getId());
        assertEquals("jane_smith", response.getUsername());
        assertEquals("jane@example.com", response.getEmail());
        assertEquals("+1987654321", response.getPhoneNumber());
        assertFalse(response.isEmailVerified());
        assertFalse(response.isPhoneVerified());
    }

    @Test
    @DisplayName("Should return null when input is null")
    void shouldHandleNullInputs() {
        assertNull(registerMapper.toEntity(null, "hash"));
        assertNull(registerMapper.toResponse(null));
    }
}
