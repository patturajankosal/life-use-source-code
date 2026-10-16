package com.lifeuse.auth.token.repository;

import com.lifeuse.auth.token.models.RefreshToken;
import com.lifeuse.user.models.User;

import java.util.Optional;

public interface ITokenRepository {

    RefreshToken save(RefreshToken refreshToken);

    Optional<RefreshToken> findByToken(String token);

    void revokeToken(String token);

    void revokeAllUserTokens(User user);
}
