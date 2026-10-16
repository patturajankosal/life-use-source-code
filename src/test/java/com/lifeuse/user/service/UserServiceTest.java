package com.lifeuse.user.service;

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
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UserService Unit Tests")
class UserServiceTest {

    @Mock
    private IUserRepository userRepository;

    @InjectMocks
    private UserService userService;

    private User testUser;

    @BeforeEach
    void setUp() {
        testUser = new User("johndoe", "John", "Doe", "john@example.com", "+1234567890", "encodedPwd", Role.ROLE_USER);
        testUser.setId(1L);
    }

    @Test
    @DisplayName("Should successfully load user details by username identifier")
    void shouldLoadUserByUsername() {
        when(userRepository.findByLoginIdentifier("johndoe")).thenReturn(Optional.of(testUser));

        UserDetails userDetails = userService.loadUserByUsername("johndoe");

        assertNotNull(userDetails);
        assertEquals("johndoe", userDetails.getUsername());
        verify(userRepository).findByLoginIdentifier("johndoe");
    }

    @Test
    @DisplayName("Should successfully load user details by email identifier")
    void shouldLoadUserByEmail() {
        when(userRepository.findByLoginIdentifier("john@example.com")).thenReturn(Optional.of(testUser));

        UserDetails userDetails = userService.loadUserByUsername("john@example.com");

        assertNotNull(userDetails);
        assertEquals("johndoe", userDetails.getUsername());
        verify(userRepository).findByLoginIdentifier("john@example.com");
    }

    @Test
    @DisplayName("Should successfully load user details by phone number identifier")
    void shouldLoadUserByPhoneNumber() {
        when(userRepository.findByLoginIdentifier("+1234567890")).thenReturn(Optional.of(testUser));

        UserDetails userDetails = userService.loadUserByUsername("+1234567890");

        assertNotNull(userDetails);
        assertEquals("johndoe", userDetails.getUsername());
        verify(userRepository).findByLoginIdentifier("+1234567890");
    }

    @Test
    @DisplayName("Should throw UsernameNotFoundException for non-existent identifier")
    void shouldThrowWhenIdentifierNotFound() {
        when(userRepository.findByLoginIdentifier("nonexistent")).thenReturn(Optional.empty());

        assertThrows(UsernameNotFoundException.class, () -> userService.loadUserByUsername("nonexistent"));
    }

    @Test
    @DisplayName("Should throw UsernameNotFoundException for blank identifier")
    void shouldThrowForBlankIdentifier() {
        assertThrows(UsernameNotFoundException.class, () -> userService.loadUserByUsername(""));
        verify(userRepository, never()).findByLoginIdentifier(any());
    }
}
