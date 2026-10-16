package com.lifeuse.auth.register.repository;

import com.lifeuse.auth.register.constants.RegisterQueries;
import com.lifeuse.common.exception.DatabaseOperationException;
import com.lifeuse.user.models.User;
import com.lifeuse.user.models.UserRowMapper;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;
import java.util.Optional;

@Repository
public class RegisterRepository implements IRegisterRepository {

    private final NamedParameterJdbcTemplate jdbcTemplate;
    private final UserRowMapper userRowMapper;

    public RegisterRepository(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
        this.userRowMapper = new UserRowMapper();
    }

    @Override
    public boolean existsByEmail(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("email", email.trim());
            Integer count = jdbcTemplate.queryForObject(RegisterQueries.EXISTS_BY_EMAIL, params, Integer.class);
            return count != null && count > 0;
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to check if email exists", ex);
        }
    }

    @Override
    public boolean existsByUsername(String username) {
        if (username == null || username.isBlank()) {
            return false;
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("username", username.trim());
            Integer count = jdbcTemplate.queryForObject(RegisterQueries.EXISTS_BY_USERNAME, params, Integer.class);
            return count != null && count > 0;
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to check if username exists", ex);
        }
    }

    @Override
    public boolean existsByPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.isBlank()) {
            return false;
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("phoneNumber", phoneNumber.trim());
            Integer count = jdbcTemplate.queryForObject(RegisterQueries.EXISTS_BY_PHONE, params, Integer.class);
            return count != null && count > 0;
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to check if phone number exists", ex);
        }
    }

    @Override
    public User save(User user) {
        Instant now = Instant.now();
        try {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("username", user.getUsername())
                    .addValue("firstName", user.getFirstName() != null ? user.getFirstName() : "")
                    .addValue("lastName", user.getLastName() != null ? user.getLastName() : "")
                    .addValue("email", user.getEmail())
                    .addValue("phoneNumber", user.getPhoneNumber())
                    .addValue("password", user.getPassword())
                    .addValue("role", user.getRole().name())
                    .addValue("emailVerified", user.isEmailVerified())
                    .addValue("phoneVerified", user.isPhoneVerified())
                    .addValue("enabled", user.isEnabled())
                    .addValue("createdAt", Timestamp.from(user.getCreatedAt() != null ? user.getCreatedAt() : now))
                    .addValue("updatedAt", Timestamp.from(user.getUpdatedAt() != null ? user.getUpdatedAt() : now));

            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(RegisterQueries.CREATE_NEW_USER, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) {
                user.setId(key.longValue());
            }
            if (user.getCreatedAt() == null) {
                user.setCreatedAt(now);
            }
            user.setUpdatedAt(now);
            return user;
        } catch (DataIntegrityViolationException ex) {
            // Rethrow so RegisterService/GlobalExceptionHandler can translate into DuplicateResourceException
            throw ex;
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to persist registered user", ex);
        }
    }

    @Override
    public Optional<User> findByEmail(String email) {
        if (email == null || email.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("email", email.trim());
            List<User> list = jdbcTemplate.query(RegisterQueries.FIND_BY_EMAIL, params, userRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to find user by email", ex);
        }
    }

    @Override
    public Optional<User> findByUsername(String username) {
        if (username == null || username.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("username", username.trim());
            List<User> list = jdbcTemplate.query(RegisterQueries.FIND_BY_USERNAME, params, userRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to find user by username", ex);
        }
    }

    @Override
    public Optional<User> findByPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("phoneNumber", phoneNumber.trim());
            List<User> list = jdbcTemplate.query(RegisterQueries.FIND_BY_PHONE, params, userRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to find user by phone number", ex);
        }
    }
}
