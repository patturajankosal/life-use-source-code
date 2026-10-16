package com.lifeuse.auth.login.repository;

import com.lifeuse.auth.login.constants.LoginQueries;
import com.lifeuse.common.exception.DatabaseOperationException;
import com.lifeuse.user.models.User;
import com.lifeuse.user.models.UserRowMapper;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class LoginRepository implements ILoginRepository {

    private final NamedParameterJdbcTemplate jdbcTemplate;
    private final UserRowMapper userRowMapper;

    public LoginRepository(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
        this.userRowMapper = new UserRowMapper();
    }

    @Override
    public Optional<User> findByLoginIdentifier(String loginIdentifier) {
        if (loginIdentifier == null || loginIdentifier.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("identifier", loginIdentifier.trim());
            List<User> list = jdbcTemplate.query(LoginQueries.FIND_BY_LOGIN_IDENTIFIER, params, userRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to query user by login identifier", ex);
        }
    }

    @Override
    public Optional<User> findByUsername(String username) {
        if (username == null || username.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("username", username.trim());
            List<User> list = jdbcTemplate.query(LoginQueries.FIND_BY_USERNAME, params, userRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to query user by username", ex);
        }
    }

    @Override
    public Optional<User> findByEmail(String email) {
        if (email == null || email.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("email", email.trim());
            List<User> list = jdbcTemplate.query(LoginQueries.FIND_BY_EMAIL, params, userRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to query user by email", ex);
        }
    }

    @Override
    public Optional<User> findByPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("phoneNumber", phoneNumber.trim());
            List<User> list = jdbcTemplate.query(LoginQueries.FIND_BY_PHONE, params, userRowMapper);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to query user by phone number", ex);
        }
    }
}
