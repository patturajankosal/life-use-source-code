package com.lifeuse.auth.token.service;

import com.lifeuse.auth.token.models.RefreshToken;
import com.lifeuse.auth.token.models.RefreshTokenRequest;
import com.lifeuse.auth.token.models.RefreshTokenResponse;
import com.lifeuse.auth.token.repository.ITokenRepository;
import com.lifeuse.common.BusinessException;
import com.lifeuse.security.JwtService;
import com.lifeuse.user.models.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.UUID;

@Service
public class TokenService implements ITokenService {

    private final ITokenRepository refreshTokenRepository;
    private final JwtService jwtService;

    @Value("${app.jwt.refresh-expiration-ms:604800000}")
    private long refreshExpirationMs;

    public TokenService(ITokenRepository refreshTokenRepository, JwtService jwtService) {
        this.refreshTokenRepository = refreshTokenRepository;
        this.jwtService = jwtService;
    }

    @Override
    @Transactional
    public RefreshToken createRefreshToken(User user) {
        String tokenString = UUID.randomUUID().toString().replace("-", "") + UUID.randomUUID().toString().replace("-", "");
        Instant expiryDate = Instant.now().plusMillis(refreshExpirationMs);

        RefreshToken refreshToken = new RefreshToken(user, tokenString, expiryDate);
        return refreshTokenRepository.save(refreshToken);
    }

    @Override
    public RefreshToken verifyExpiration(RefreshToken token) {
        if (token.getExpiryDate().isBefore(Instant.now())) {
            refreshTokenRepository.revokeToken(token.getToken());
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.TOKEN_EXPIRED, "Refresh token has expired. Please log in again.");
        }
        return token;
    }

    @Override
    @Transactional
    public RefreshTokenResponse refreshToken(RefreshTokenRequest request) {
        String requestToken = request.getRefreshToken().trim();

        RefreshToken refreshToken = refreshTokenRepository.findByToken(requestToken)
                .orElseThrow(() -> new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.AUTHENTICATION_REQUIRED, "Refresh token does not exist"));

        if (refreshToken.isRevoked()) {
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.TOKEN_EXPIRED, "Refresh token has been revoked. Please log in again.");
        }

        verifyExpiration(refreshToken);

        User user = refreshToken.getUser();
        String newAccessToken = jwtService.generateToken(user);

        // Refresh token rotation: revoke old token and create new
        refreshTokenRepository.revokeToken(requestToken);
        String newRefreshTokenString = UUID.randomUUID().toString().replace("-", "") + UUID.randomUUID().toString().replace("-", "");
        RefreshToken newRefreshToken = new RefreshToken(user, newRefreshTokenString, Instant.now().plusMillis(refreshExpirationMs));
        refreshTokenRepository.save(newRefreshToken);

        return new RefreshTokenResponse(
                newAccessToken,
                newRefreshTokenString,
                jwtService.getJwtExpirationMs() / 1000
        );
    }

    @Override
    @Transactional
    public void revokeUserTokens(User user) {
        refreshTokenRepository.revokeAllUserTokens(user);
    }

    @Override
    @Transactional
    public void revokeToken(String token) {
        refreshTokenRepository.revokeToken(token);
    }
}
