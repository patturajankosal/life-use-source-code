package com.lifeuse.auth.verification.repository;

import com.lifeuse.auth.verification.models.OtpType;
import com.lifeuse.auth.verification.models.OtpVerification;
import com.lifeuse.user.models.User;

import java.util.Optional;

public interface IVerificationRepository {

    OtpVerification save(OtpVerification otpVerification);

    Optional<OtpVerification> findTopByUserAndTypeAndVerifiedFalseOrderByCreatedAtDesc(User user, OtpType type);

    Optional<OtpVerification> findTopByIdentifierAndTypeAndVerifiedFalseOrderByCreatedAtDesc(String identifier, OtpType type);

    Optional<OtpVerification> findTopByTokenAndVerifiedTrue(String token);

    void updateVerified(Long id, boolean verified);

    void updateVerifiedAndToken(Long id, boolean verified, String token);

    void incrementAttempts(Long id, int attempts);
}
