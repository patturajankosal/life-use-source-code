package com.lifeuse.auth.password.repository;

import com.lifeuse.auth.password.models.PasswordResetToken;

import java.util.Optional;

public interface IPasswordResetRepository {

    PasswordResetToken save(PasswordResetToken token);

    Optional<PasswordResetToken> findByToken(String token);

    void markAsUsed(Long id);
}
