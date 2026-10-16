package com.lifeuse.auth.verification.repository;

import com.lifeuse.auth.verification.models.OtpType;
import com.lifeuse.auth.verification.models.OtpVerification;
import com.lifeuse.user.models.User;

import java.util.Optional;

public interface IVerificationRepository {

    OtpVerification save(OtpVerification otpVerification);

    Optional<OtpVerification> findTopByUserAndTypeAndVerifiedFalseOrderByCreatedAtDesc(User user, OtpType type);

    void updateVerified(Long id, boolean verified);

    void incrementAttempts(Long id, int attempts);
}
