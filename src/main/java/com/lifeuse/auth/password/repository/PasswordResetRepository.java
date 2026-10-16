package com.lifeuse.auth.password.repository;

import com.lifeuse.auth.password.constants.PasswordResetQueries;
import com.lifeuse.auth.password.models.PasswordResetToken;
import com.lifeuse.common.exception.DatabaseOperationException;
import com.lifeuse.user.models.User;
import com.lifeuse.user.repository.IUserRepository;
import org.springframework.dao.DataAccessException;
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
public class PasswordResetRepository implements IPasswordResetRepository {

    private final NamedParameterJdbcTemplate jdbcTemplate;
    private final IUserRepository userRepository;

    public PasswordResetRepository(NamedParameterJdbcTemplate jdbcTemplate, IUserRepository userRepository) {
        this.jdbcTemplate = jdbcTemplate;
        this.userRepository = userRepository;
    }

    @Override
    public PasswordResetToken save(PasswordResetToken token) {
        Instant now = Instant.now();
        try {
            if (token.getId() == null) {
                MapSqlParameterSource params = new MapSqlParameterSource()
                        .addValue("userId", token.getUser().getId())
                        .addValue("token", token.getToken())
                        .addValue("expiresAt", Timestamp.from(token.getExpiresAt()))
                        .addValue("used", token.isUsed())
                        .addValue("createdAt", Timestamp.from(token.getCreatedAt() != null ? token.getCreatedAt() : now));

                KeyHolder keyHolder = new GeneratedKeyHolder();
                jdbcTemplate.update(PasswordResetQueries.CREATE_RESET_TOKEN, params, keyHolder, new String[]{"id"});
                Number key = keyHolder.getKey();
                if (key != null) {
                    token.setId(key.longValue());
                }
                if (token.getCreatedAt() == null) {
                    token.setCreatedAt(now);
                }
                return token;
            } else {
                markAsUsed(token.getId());
                return token;
            }
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to save password reset token", ex);
        }
    }

    @Override
    public Optional<PasswordResetToken> findByToken(String token) {
        if (token == null || token.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("token", token.trim());
            List<PasswordResetToken> list = jdbcTemplate.query(PasswordResetQueries.FIND_BY_TOKEN, params, (rs, rowNum) -> {
                PasswordResetToken prt = new PasswordResetToken();
                prt.setId(rs.getLong("id"));
                Long userId = rs.getLong("user_id");
                userRepository.findById(userId).ifPresent(prt::setUser);
                prt.setToken(rs.getString("token"));
                prt.setExpiresAt(rs.getTimestamp("expires_at").toInstant());
                prt.setUsed(rs.getBoolean("used"));
                prt.setCreatedAt(rs.getTimestamp("created_at").toInstant());
                return prt;
            });

            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to find password reset token", ex);
        }
    }

    @Override
    public void markAsUsed(Long id) {
        if (id == null) {
            return;
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("id", id);
            jdbcTemplate.update(PasswordResetQueries.MARK_TOKEN_AS_USED, params);
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to mark password reset token as used", ex);
        }
    }
}
