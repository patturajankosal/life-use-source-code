package com.lifeuse.security;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
@ActiveProfiles("test")
@DisplayName("Spring Security Filter Chain Startup Verification Test")
class SecurityStartupTest {

    @Autowired(required = false)
    private SecurityFilterChain securityFilterChain;

    @Test
    @DisplayName("Should initialize SecurityFilterChain without registered order exception")
    void shouldInitializeSecurityFilterChainSuccessfully() {
        assertNotNull(securityFilterChain, "SecurityFilterChain must be initialized successfully");
    }
}
