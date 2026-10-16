package com.lifeuse.auth.token.service;

import com.lifeuse.auth.token.models.RefreshToken;
import com.lifeuse.auth.token.models.RefreshTokenRequest;
import com.lifeuse.auth.token.models.RefreshTokenResponse;
import com.lifeuse.user.models.User;

public interface ITokenService {

    RefreshToken createRefreshToken(User user);

    RefreshToken verifyExpiration(RefreshToken token);

    RefreshTokenResponse refreshToken(RefreshTokenRequest request);

    void revokeToken(String token);

    void revokeUserTokens(User user);
}
