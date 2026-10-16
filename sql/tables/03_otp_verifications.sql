-- =============================================================================
-- Table: otp_verifications
-- Description: Stores OTP codes for email/SMS account verification & reset.
-- =============================================================================

-- 1. Drop existing table if recreating (uncomment if you want a clean reset)
-- DROP TABLE IF EXISTS otp_verifications CASCADE;

-- 2. Create the otp_verifications table
CREATE TABLE IF NOT EXISTS otp_verifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    otp_code VARCHAR(10) NOT NULL,
    type VARCHAR(20) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    verified BOOLEAN NOT NULL DEFAULT FALSE,
    attempts INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. Indexes for fast OTP validation
CREATE INDEX IF NOT EXISTS idx_otp_user_type ON otp_verifications(user_id, type);
CREATE INDEX IF NOT EXISTS idx_otp_expires_at ON otp_verifications(expires_at);

COMMENT ON TABLE otp_verifications IS 'Stores verification codes for registration and password reset';
