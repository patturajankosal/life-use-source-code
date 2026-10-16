package com.lifeuse.auth.login.service;

import com.lifeuse.auth.login.models.LoginMapper;
import com.lifeuse.auth.login.models.LoginRequest;
import com.lifeuse.auth.login.models.LoginResponse;
import com.lifeuse.auth.login.repository.ILoginRepository;
import com.lifeuse.auth.token.models.RefreshToken;
import com.lifeuse.auth.token.service.ITokenService;
import com.lifeuse.common.ResourceNotFoundException;
import com.lifeuse.security.JwtService;
import com.lifeuse.user.models.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LoginService implements ILoginService {

    private static final Logger log = LoggerFactory.getLogger(LoginService.class);

    private final AuthenticationManager authenticationManager;
    private final ILoginRepository loginRepository;
    private final JwtService jwtService;
    private final ITokenService tokenService;
    private final LoginMapper loginMapper;

    public LoginService(AuthenticationManager authenticationManager,
                        ILoginRepository loginRepository,
                        JwtService jwtService,
                        ITokenService tokenService,
                        LoginMapper loginMapper) {
        this.authenticationManager = authenticationManager;
        this.loginRepository = loginRepository;
        this.jwtService = jwtService;
        this.tokenService = tokenService;
        this.loginMapper = loginMapper;
    }

    @Override
    @Transactional
    public LoginResponse login(LoginRequest request) {
        String rawIdentifier = request.getIdentifier();
        if (rawIdentifier == null || rawIdentifier.isBlank()) {
            throw new BadCredentialsException("Login identifier cannot be empty");
        }

        String normalizedIdentifier = rawIdentifier.trim();

        // 1. Authenticate via Spring Security (validates credentials against BCrypt hash & checks account status)
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(normalizedIdentifier, request.getPassword())
        );

        // 2. Fetch authenticated user deterministically by login identifier
        User user;
        if (authentication.getPrincipal() instanceof User authenticatedUser) {
            user = authenticatedUser;
        } else {
            user = loginRepository.findByLoginIdentifier(normalizedIdentifier)
                    .orElseThrow(() -> new ResourceNotFoundException("User", "identifier", normalizedIdentifier));
        }

        // 3. Issue JWT access token and persisted refresh token
        String accessToken = jwtService.generateToken(user);
        RefreshToken refreshToken = tokenService.createRefreshToken(user);
        long expiresInSeconds = jwtService.getJwtExpirationMs() / 1000;

        log.info("User ID: {} (Username: {}) successfully authenticated", user.getId(), user.getUsername());

        // 4. Return safe, authorized profile data & tokens
        return loginMapper.toResponse(user, accessToken, refreshToken.getToken(), expiresInSeconds);
    }
}
