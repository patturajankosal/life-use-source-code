package com.lifeuse.auth.verification.constants;

public final class VerificationQueries {

    private VerificationQueries() {
        // Prevent instantiation
    }

    public static final String CREATE_OTP =
            "INSERT INTO otp_verifications (user_id, otp_code, type, expires_at, verified, attempts, created_at) " +
            "VALUES (:userId, :otpCode, :type, :expiresAt, :verified, :attempts, :createdAt)";

    public static final String FIND_ACTIVE_OTP =
            "SELECT id, user_id, otp_code, type, expires_at, verified, attempts, created_at " +
            "FROM otp_verifications " +
            "WHERE user_id = :userId AND type = :type AND verified = false " +
            "ORDER BY created_at DESC LIMIT 1";

    public static final String UPDATE_OTP_VERIFIED =
            "UPDATE otp_verifications SET verified = :verified WHERE id = :id";

    public static final String INCREMENT_OTP_ATTEMPTS =
            "UPDATE otp_verifications SET attempts = :attempts WHERE id = :id";

    public static final String UPDATE_USER_EMAIL_VERIFIED =
            "UPDATE users SET email_verified = true, updated_at = :updatedAt WHERE id = :id";

    public static final String UPDATE_USER_PHONE_VERIFIED =
            "UPDATE users SET phone_verified = true, updated_at = :updatedAt WHERE id = :id";
}
