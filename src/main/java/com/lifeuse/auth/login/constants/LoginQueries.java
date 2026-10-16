package com.lifeuse.auth.login.constants;

public final class LoginQueries {

    private LoginQueries() {
        // Prevent instantiation
    }

    public static final String FIND_BY_LOGIN_IDENTIFIER =
            "SELECT id, username, first_name, last_name, email, phone_number, password, role, email_verified, phone_verified, enabled, created_at, updated_at " +
            "FROM users " +
            "WHERE LOWER(username) = LOWER(:identifier) " +
            "   OR LOWER(email) = LOWER(:identifier) " +
            "   OR phone_number = :identifier";

    public static final String FIND_BY_USERNAME =
            "SELECT id, username, first_name, last_name, email, phone_number, password, role, email_verified, phone_verified, enabled, created_at, updated_at " +
            "FROM users WHERE LOWER(username) = LOWER(:username)";

    public static final String FIND_BY_EMAIL =
            "SELECT id, username, first_name, last_name, email, phone_number, password, role, email_verified, phone_verified, enabled, created_at, updated_at " +
            "FROM users WHERE LOWER(email) = LOWER(:email)";

    public static final String FIND_BY_PHONE =
            "SELECT id, username, first_name, last_name, email, phone_number, password, role, email_verified, phone_verified, enabled, created_at, updated_at " +
            "FROM users WHERE phone_number = :phoneNumber";
}
