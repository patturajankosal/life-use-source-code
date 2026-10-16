-- V2__add_username_and_unique_indexes.sql
-- Incremental schema migration for username and strict unique constraint enforcement

ALTER TABLE users ADD COLUMN IF NOT EXISTS username VARCHAR(50);

-- Backfill username with email prefix if any existing rows lack username
UPDATE users SET username = LOWER(SPLIT_PART(email, '@', 1)) WHERE username IS NULL;

-- Enforce NOT NULL and UNIQUE on username
ALTER TABLE users ALTER COLUMN username SET NOT NULL;

-- Create case-insensitive unique indexes for deterministic lookups
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_username_lower ON users(LOWER(username));
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email_lower ON users(LOWER(email));
