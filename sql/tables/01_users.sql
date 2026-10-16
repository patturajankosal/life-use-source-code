-- =============================================================================
-- Table: users
-- Description: Core authentication and user management table.
-- Compatible with: PostgreSQL 12+
-- =============================================================================

-- 1. Drop existing table if recreating (uncomment if you want a clean reset)
-- DROP TABLE IF EXISTS users CASCADE;

-- 2. Create the users table
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone_number VARCHAR(25) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'ROLE_USER',
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. Create performance and unique indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_username_lower ON users(LOWER(username));
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email_lower ON users(LOWER(email));
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_phone_number ON users(phone_number);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- 4. Column documentation
COMMENT ON TABLE users IS 'Stores registered users, credentials, roles, and status';
COMMENT ON COLUMN users.id IS 'Auto-incrementing unique user identifier';
COMMENT ON COLUMN users.username IS 'Unique alphanumeric username';
COMMENT ON COLUMN users.email IS 'Unique user email address';
COMMENT ON COLUMN users.role IS 'ROLE_USER (User), ROLE_CUSTOMER (Customer), ROLE_ADMIN (Admin), ROLE_SUPER_ADMIN (SuperAdmin)';
COMMENT ON COLUMN users.password IS 'BCrypt hashed password';
