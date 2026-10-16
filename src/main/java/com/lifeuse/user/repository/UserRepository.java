package com.lifeuse.user.repository;

import com.lifeuse.common.exception.DatabaseOperationException;
import com.lifeuse.user.constants.UserQueries;
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
public class UserRepository implements IUserRepository {

    private final NamedParameterJdbcTemplate jdbcTemplate;
    private final UserRowMapper userRowMapper;

    public UserRepository(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
        this.userRowMapper = new UserRowMapper();
    }

    @Override
    public Optional<User> findById(Long id) {
        if (id == null) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("id", id);
            List<User> results = jdbcTemplate.query(UserQueries.FIND_BY_ID, params, userRowMapper);
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to query user by ID", ex);
        }
    }

    @Override
    public Optional<User> findByLoginIdentifier(String loginIdentifier) {
        if (loginIdentifier == null || loginIdentifier.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("identifier", loginIdentifier.trim());
            List<User> results = jdbcTemplate.query(UserQueries.FIND_BY_LOGIN_IDENTIFIER, params, userRowMapper);
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to query user by login identifier", ex);
        }
    }

    @Override
    public Optional<User> findByEmail(String email) {
        if (email == null || email.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("email", email.trim());
            List<User> results = jdbcTemplate.query(UserQueries.FIND_BY_EMAIL, params, userRowMapper);
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to query user by email", ex);
        }
    }

    @Override
    public Optional<User> findByUsername(String username) {
        if (username == null || username.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("username", username.trim());
            List<User> results = jdbcTemplate.query(UserQueries.FIND_BY_USERNAME, params, userRowMapper);
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to query user by username", ex);
        }
    }

    @Override
    public Optional<User> findByPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("phoneNumber", phoneNumber.trim());
            List<User> results = jdbcTemplate.query(UserQueries.FIND_BY_PHONE, params, userRowMapper);
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to query user by phone number", ex);
        }
    }

    @Override
    public boolean existsByEmail(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("email", email.trim());
            Integer count = jdbcTemplate.queryForObject(UserQueries.EXISTS_BY_EMAIL, params, Integer.class);
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
            Integer count = jdbcTemplate.queryForObject(UserQueries.EXISTS_BY_USERNAME, params, Integer.class);
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
            Integer count = jdbcTemplate.queryForObject(UserQueries.EXISTS_BY_PHONE, params, Integer.class);
            return count != null && count > 0;
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to check if phone number exists", ex);
        }
    }

    @Override
    public User save(User user) {
        Instant now = Instant.now();
        try {
            if (user.getId() == null) {
                MapSqlParameterSource params = new MapSqlParameterSource()
                        .addValue("username", user.getUsername())
                        .addValue("firstName", user.getFirstName())
                        .addValue("lastName", user.getLastName())
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
                jdbcTemplate.update(UserQueries.CREATE_USER, params, keyHolder, new String[]{"id"});
                Number key = keyHolder.getKey();
                if (key != null) {
                    user.setId(key.longValue());
                }
                if (user.getCreatedAt() == null) {
                    user.setCreatedAt(now);
                }
                user.setUpdatedAt(now);
                return user;
            } else {
                MapSqlParameterSource params = new MapSqlParameterSource()
                        .addValue("id", user.getId())
                        .addValue("firstName", user.getFirstName())
                        .addValue("lastName", user.getLastName())
                        .addValue("email", user.getEmail())
                        .addValue("phoneNumber", user.getPhoneNumber())
                        .addValue("password", user.getPassword())
                        .addValue("role", user.getRole().name())
                        .addValue("emailVerified", user.isEmailVerified())
                        .addValue("phoneVerified", user.isPhoneVerified())
                        .addValue("enabled", user.isEnabled())
                        .addValue("updatedAt", Timestamp.from(now));

                jdbcTemplate.update(UserQueries.UPDATE_USER, params);
                user.setUpdatedAt(now);
                return user;
            }
        } catch (DataIntegrityViolationException ex) {
            throw ex;
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to persist user", ex);
        }
    }
}
