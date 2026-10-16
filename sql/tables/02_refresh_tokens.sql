-- =============================================================================
-- Table: refresh_tokens
-- Description: Stores JWT refresh tokens for user authentication sessions.
-- =============================================================================

-- 1. Drop existing table if recreating (uncomment if you want a clean reset)
-- DROP TABLE IF EXISTS refresh_tokens CASCADE;

-- 2. Create the refresh_tokens table
CREATE TABLE IF NOT EXISTS refresh_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) NOT NULL UNIQUE,
    expiry_date TIMESTAMP WITH TIME ZONE NOT NULL,
    revoked BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. Indexes for fast token lookup and user session queries
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_token ON refresh_tokens(token);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user_id ON refresh_tokens(user_id);

COMMENT ON TABLE refresh_tokens IS 'Stores JWT refresh tokens for active login sessions';
