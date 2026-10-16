-- =============================================================================
-- Table: password_reset_tokens
-- Description: Stores secure one-time tokens for password recovery.
-- =============================================================================

-- 1. Drop existing table if recreating (uncomment if you want a clean reset)
-- DROP TABLE IF EXISTS password_reset_tokens CASCADE;

-- 2. Create the password_reset_tokens table
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. Indexes for fast lookup
CREATE INDEX IF NOT EXISTS idx_pwd_reset_token ON password_reset_tokens(token);
CREATE INDEX IF NOT EXISTS idx_pwd_reset_user_id ON password_reset_tokens(user_id);

COMMENT ON TABLE password_reset_tokens IS 'Stores one-time password recovery tokens';
