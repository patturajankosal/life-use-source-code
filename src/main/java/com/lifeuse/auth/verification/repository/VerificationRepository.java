package com.lifeuse.auth.verification.repository;

import com.lifeuse.auth.verification.constants.VerificationQueries;
import com.lifeuse.auth.verification.models.OtpType;
import com.lifeuse.auth.verification.models.OtpVerification;
import com.lifeuse.common.exception.DatabaseOperationException;
import com.lifeuse.user.models.User;
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
public class VerificationRepository implements IVerificationRepository {

    private final NamedParameterJdbcTemplate jdbcTemplate;

    public VerificationRepository(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public OtpVerification save(OtpVerification otpVerification) {
        Instant now = Instant.now();
        try {
            if (otpVerification.getId() == null) {
                MapSqlParameterSource params = new MapSqlParameterSource()
                        .addValue("userId", otpVerification.getUser().getId())
                        .addValue("otpCode", otpVerification.getOtpCode())
                        .addValue("type", otpVerification.getType().name())
                        .addValue("expiresAt", Timestamp.from(otpVerification.getExpiresAt()))
                        .addValue("verified", otpVerification.isVerified())
                        .addValue("attempts", otpVerification.getAttempts())
                        .addValue("createdAt", Timestamp.from(otpVerification.getCreatedAt() != null ? otpVerification.getCreatedAt() : now));

                KeyHolder keyHolder = new GeneratedKeyHolder();
                jdbcTemplate.update(VerificationQueries.CREATE_OTP, params, keyHolder, new String[]{"id"});
                Number key = keyHolder.getKey();
                if (key != null) {
                    otpVerification.setId(key.longValue());
                }
                if (otpVerification.getCreatedAt() == null) {
                    otpVerification.setCreatedAt(now);
                }
                return otpVerification;
            } else {
                updateVerified(otpVerification.getId(), otpVerification.isVerified());
                return otpVerification;
            }
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to save OTP verification record", ex);
        }
    }

    @Override
    public Optional<OtpVerification> findTopByUserAndTypeAndVerifiedFalseOrderByCreatedAtDesc(User user, OtpType type) {
        if (user == null || user.getId() == null) {
            return Optional.empty();
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("userId", user.getId())
                    .addValue("type", type.name());

            List<OtpVerification> list = jdbcTemplate.query(VerificationQueries.FIND_ACTIVE_OTP, params, (rs, rowNum) -> {
                OtpVerification otp = new OtpVerification();
                otp.setId(rs.getLong("id"));
                otp.setUser(user);
                otp.setOtpCode(rs.getString("otp_code"));
                otp.setType(OtpType.valueOf(rs.getString("type")));
                otp.setExpiresAt(rs.getTimestamp("expires_at").toInstant());
                otp.setVerified(rs.getBoolean("verified"));
                otp.setAttempts(rs.getInt("attempts"));
                otp.setCreatedAt(rs.getTimestamp("created_at").toInstant());
                return otp;
            });

            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to find active OTP verification", ex);
        }
    }

    @Override
    public void updateVerified(Long id, boolean verified) {
        if (id == null) {
            return;
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("id", id)
                    .addValue("verified", verified);
            jdbcTemplate.update(VerificationQueries.UPDATE_OTP_VERIFIED, params);
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to update OTP verified status", ex);
        }
    }

    @Override
    public void incrementAttempts(Long id, int attempts) {
        if (id == null) {
            return;
        }
        try {
            MapSqlParameterSource params = new MapSqlParameterSource()
                    .addValue("id", id)
                    .addValue("attempts", attempts);
            jdbcTemplate.update(VerificationQueries.INCREMENT_OTP_ATTEMPTS, params);
        } catch (DataAccessException ex) {
            throw new DatabaseOperationException("Failed to increment OTP attempts", ex);
        }
    }
}
