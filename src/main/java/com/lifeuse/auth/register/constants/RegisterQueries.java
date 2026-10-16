package com.lifeuse.auth.register.constants;

public final class RegisterQueries {

    private RegisterQueries() {
        // Prevent instantiation
    }

    public static final String CREATE_NEW_USER =
            "INSERT INTO users (username, first_name, last_name, email, phone_number, password, role, email_verified, phone_verified, enabled, created_at, updated_at) " +
            "VALUES (:username, :firstName, :lastName, :email, :phoneNumber, :password, :role, :emailVerified, :phoneVerified, :enabled, :createdAt, :updatedAt)";

    public static final String EXISTS_BY_EMAIL =
            "SELECT COUNT(1) FROM users WHERE LOWER(email) = LOWER(:email)";

    public static final String EXISTS_BY_USERNAME =
            "SELECT COUNT(1) FROM users WHERE LOWER(username) = LOWER(:username)";

    public static final String EXISTS_BY_PHONE =
            "SELECT COUNT(1) FROM users WHERE phone_number = :phoneNumber";

    public static final String FIND_BY_EMAIL =
            "SELECT id, username, first_name, last_name, email, phone_number, password, role, email_verified, phone_verified, enabled, created_at, updated_at " +
            "FROM users WHERE LOWER(email) = LOWER(:email)";

    public static final String FIND_BY_USERNAME =
            "SELECT id, username, first_name, last_name, email, phone_number, password, role, email_verified, phone_verified, enabled, created_at, updated_at " +
            "FROM users WHERE LOWER(username) = LOWER(:username)";

    public static final String FIND_BY_PHONE =
            "SELECT id, username, first_name, last_name, email, phone_number, password, role, email_verified, phone_verified, enabled, created_at, updated_at " +
            "FROM users WHERE phone_number = :phoneNumber";
}
