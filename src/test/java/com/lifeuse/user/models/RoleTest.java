package com.lifeuse.user.models;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Role Enum Architecture Tests")
class RoleTest {

    @Test
    @DisplayName("Should verify all 4 required roles exist: USER, CUSTOMER, ADMIN, SUPER_ADMIN")
    void shouldVerifyAllFourRolesExist() {
        assertNotNull(Role.ROLE_USER);
        assertNotNull(Role.ROLE_CUSTOMER);
        assertNotNull(Role.ROLE_ADMIN);
        assertNotNull(Role.ROLE_SUPER_ADMIN);

        assertEquals("User", Role.ROLE_USER.getDisplayName());
        assertEquals("Customer", Role.ROLE_CUSTOMER.getDisplayName());
        assertEquals("Admin", Role.ROLE_ADMIN.getDisplayName());
        assertEquals("SuperAdmin", Role.ROLE_SUPER_ADMIN.getDisplayName());
    }

    @Test
    @DisplayName("Should parse roles from various string representations")
    void shouldParseRolesFromString() {
        // Standard strings
        assertEquals(Role.ROLE_USER, Role.fromString("User"));
        assertEquals(Role.ROLE_CUSTOMER, Role.fromString("Customer"));
        assertEquals(Role.ROLE_ADMIN, Role.fromString("Admin"));
        assertEquals(Role.ROLE_SUPER_ADMIN, Role.fromString("SuperAdmin"));

        // Spring Security prefixed strings
        assertEquals(Role.ROLE_USER, Role.fromString("ROLE_USER"));
        assertEquals(Role.ROLE_CUSTOMER, Role.fromString("ROLE_CUSTOMER"));
        assertEquals(Role.ROLE_ADMIN, Role.fromString("ROLE_ADMIN"));
        assertEquals(Role.ROLE_SUPER_ADMIN, Role.fromString("ROLE_SUPER_ADMIN"));

        // Case-insensitivity & variations
        assertEquals(Role.ROLE_USER, Role.fromString("user"));
        assertEquals(Role.ROLE_CUSTOMER, Role.fromString("customer"));
        assertEquals(Role.ROLE_ADMIN, Role.fromString("admin"));
        assertEquals(Role.ROLE_SUPER_ADMIN, Role.fromString("superadmin"));
        assertEquals(Role.ROLE_SUPER_ADMIN, Role.fromString("ROLE_SUPERADMIN"));

        // Null / blank fallback
        assertEquals(Role.ROLE_USER, Role.fromString(null));
        assertEquals(Role.ROLE_USER, Role.fromString(""));
        assertEquals(Role.ROLE_USER, Role.fromString("  "));
    }
}
