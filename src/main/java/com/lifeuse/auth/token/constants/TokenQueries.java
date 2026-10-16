package com.lifeuse.auth.token.constants;

public final class TokenQueries {

    private TokenQueries() {
        // Prevent instantiation
    }

    public static final String CREATE_REFRESH_TOKEN =
            "INSERT INTO refresh_tokens (user_id, token, expiry_date, revoked, created_at) " +
            "VALUES (:userId, :token, :expiryDate, :revoked, :createdAt)";

    public static final String FIND_BY_TOKEN =
            "SELECT id, user_id, token, expiry_date, revoked, created_at " +
            "FROM refresh_tokens " +
            "WHERE token = :token";

    public static final String REVOKE_BY_TOKEN =
            "UPDATE refresh_tokens SET revoked = true WHERE token = :token";

    public static final String REVOKE_ALL_USER_TOKENS =
            "UPDATE refresh_tokens SET revoked = true WHERE user_id = :userId";
}
