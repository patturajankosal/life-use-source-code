package com.lifeuse.auth.password.constants;

public final class PasswordResetQueries {

    private PasswordResetQueries() {
        // Prevent instantiation
    }

    public static final String CREATE_RESET_TOKEN =
            "INSERT INTO password_reset_tokens (user_id, token, expires_at, used, created_at) " +
            "VALUES (:userId, :token, :expiresAt, :used, :createdAt)";

    public static final String FIND_BY_TOKEN =
            "SELECT id, user_id, token, expires_at, used, created_at " +
            "FROM password_reset_tokens " +
            "WHERE token = :token";

    public static final String MARK_TOKEN_AS_USED =
            "UPDATE password_reset_tokens SET used = true WHERE id = :id";

    public static final String UPDATE_USER_PASSWORD =
            "UPDATE users SET password = :password, updated_at = :updatedAt WHERE id = :id";
}
