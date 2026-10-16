package com.lifeuse.auth.token.repository;

import com.lifeuse.auth.token.constants.TokenQueries;
import com.lifeuse.auth.token.models.RefreshToken;
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
public class TokenRepository implements ITokenRepository {

    private final NamedParameterJdbcTemplate jdbcTemplate;
    private final IUserRepository userRepository;

    public TokenRepository(NamedParameterJdbcTemplate jdbcTemplate, IUserRepository userRepository) {
        this.jdbcTemplate = jdbcTemplate;
        this.userRepository = userRepository;
    }

    @Override
    public RefreshToken save(RefreshToken refreshToken) {
        Instant now = Instant.now();
        try {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", refreshToken.getUser().getId())
                    .addValue("token", refreshToken.getToken())
                    .addValue("expiryDate", Timestamp.from(refreshToken.getExpiryDate()))
                    .addValue("revoked", refreshToken.isRevoked())
                    .addValue("createdAt", Timestamp.from(refreshToken.getCreatedAt() != null ? refreshToken.getCreatedAt() : now));

            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(TokenQueries.CREATE_REFRESH_TOKEN, params, keyHolder, new String[]{"id"});
            Number key = keyHolder.getKey();
            if (key != null) {
                refreshToken.setId(key.longValue());
            }
            if (refreshToken.getCreatedAt() == null) {
                refreshToken.setCreatedAt(now);
            }
            return refreshToken;
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to persist refresh token", ex);
        }
    }

    @Override
    public Optional<RefreshToken> findByToken(String token) {
        if (token == null || token.isBlank()) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("token", token.trim());
            List<RefreshToken> list = jdbcTemplate.query(TokenQueries.FIND_BY_TOKEN, params, (rs, rowNum) -> {
                RefreshToken rt = new RefreshToken();
                rt.setId(rs.getLong("id"));
                Long userId = rs.getLong("user_id");
                userRepository.findById(userId).ifPresent(rt::setUser);
                rt.setToken(rs.getString("token"));
                rt.setExpiryDate(rs.getTimestamp("expiry_date").toInstant());
                rt.setRevoked(rs.getBoolean("revoked"));
                rt.setCreatedAt(rs.getTimestamp("created_at").toInstant());
                return rt;
            });
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to find refresh token", ex);
        }
    }

    @Override
    public void revokeToken(String token) {
        if (token == null || token.isBlank()) {
            return;
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("token", token.trim());
            jdbcTemplate.update(TokenQueries.REVOKE_BY_TOKEN, params);
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to revoke refresh token", ex);
        }
    }

    @Override
    public void revokeAllUserTokens(User user) {
        if (user == null || user.getId() == null) {
            return;
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource("userId", user.getId());
            jdbcTemplate.update(TokenQueries.REVOKE_ALL_USER_TOKENS, params);
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to revoke all user refresh tokens", ex);
        }
    }
}
