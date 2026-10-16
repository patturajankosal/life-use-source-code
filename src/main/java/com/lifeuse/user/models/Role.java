package com.lifeuse.user.models;

/**
 * Application Roles:
 * - USER        (ROLE_USER)        : Standard mobile application user
 * - CUSTOMER    (ROLE_CUSTOMER)    : Customer / client account
 * - ADMIN       (ROLE_ADMIN)       : System / business administrator
 * - SUPER_ADMIN (ROLE_SUPER_ADMIN) : Super administrator with full privileges
 */
public enum Role {
    ROLE_USER("User"),
    ROLE_CUSTOMER("Customer"),
    ROLE_ADMIN("Admin"),
    ROLE_SUPER_ADMIN("SuperAdmin");

    private final String displayName;

    Role(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    /**
     * Case-insensitive, robust parsing from string:
     * Supports "User", "ROLE_USER", "Customer", "ROLE_CUSTOMER",
     * "Admin", "ROLE_ADMIN", "SuperAdmin", "ROLE_SUPER_ADMIN", "ROLE_SUPERADMIN".
     */
    public static Role fromString(String roleStr) {
        if (roleStr == null || roleStr.isBlank()) {
            return ROLE_USER;
        }
        String clean = roleStr.trim();
        for (Role r : values()) {
            if (r.name().equalsIgnoreCase(clean) || r.displayName.equalsIgnoreCase(clean)) {
                return r;
            }
        }
        String withPrefix = clean.toUpperCase().startsWith("ROLE_")
                ? clean.toUpperCase()
                : "ROLE_" + clean.toUpperCase();
        if (withPrefix.equals("ROLE_SUPERADMIN")) {
            return ROLE_SUPER_ADMIN;
        }
        try {
            return Role.valueOf(withPrefix);
        } catch (IllegalArgumentException e) {
            return ROLE_USER;
        }
    }
}
