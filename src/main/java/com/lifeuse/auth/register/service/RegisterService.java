package com.lifeuse.auth.register.service;

import com.lifeuse.auth.register.models.RegisterMapper;
import com.lifeuse.auth.register.models.RegisterRequest;
import com.lifeuse.auth.register.models.RegisterResponse;
import com.lifeuse.auth.register.repository.IRegisterRepository;
import com.lifeuse.auth.verification.service.IVerificationService;
import com.lifeuse.common.BusinessException;
import com.lifeuse.common.DuplicateResourceException;
import com.lifeuse.user.models.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RegisterService implements IRegisterService {

    private static final Logger log = LoggerFactory.getLogger(RegisterService.class);

    private final IRegisterRepository registerRepository;
    private final RegisterMapper registerMapper;
    private final PasswordEncoder passwordEncoder;
    private final IVerificationService verificationService;
    private final com.lifeuse.security.JwtService jwtService;
    private final com.lifeuse.auth.token.service.ITokenService tokenService;

    public RegisterService(IRegisterRepository registerRepository,
                           RegisterMapper registerMapper,
                           PasswordEncoder passwordEncoder,
                           IVerificationService verificationService,
                           com.lifeuse.security.JwtService jwtService,
                           com.lifeuse.auth.token.service.ITokenService tokenService) {
        this.registerRepository = registerRepository;
        this.registerMapper = registerMapper;
        this.passwordEncoder = passwordEncoder;
        this.verificationService = verificationService;
        this.jwtService = jwtService;
        this.tokenService = tokenService;
    }

    @Override
    @Transactional
    public RegisterResponse register(RegisterRequest request) {
        // 1. Password confirmation check
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new BusinessException("Password and confirm password do not match");
        }

        // 2. Normalize inputs
        String normalizedUsername = request.getUsername().trim();
        String normalizedEmail = (request.getEmail() != null && !request.getEmail().isBlank())
                ? request.getEmail().trim().toLowerCase() : null;
        String normalizedPhone = (request.getPhoneNumber() != null && !request.getPhoneNumber().isBlank())
                ? request.getPhoneNumber().trim() : null;

        if (normalizedEmail == null && normalizedPhone == null) {
            throw new BusinessException("At least one contact method (email or phone number) is required.");
        }

        // 3. Pre-check uniqueness across unique identifiers
        if (normalizedEmail != null && registerRepository.existsByEmail(normalizedEmail)) {
            throw new DuplicateResourceException(String.format("An account with email '%s' already exists.", normalizedEmail));
        }
        if (registerRepository.existsByUsername(normalizedUsername)) {
            throw new DuplicateResourceException(String.format("An account with username '%s' already exists.", normalizedUsername));
        }
        if (normalizedPhone != null && registerRepository.existsByPhoneNumber(normalizedPhone)) {
            throw new DuplicateResourceException(String.format("An account with phone number '%s' already exists.", normalizedPhone));
        }

        // 4. Hash password securely
        String encodedPassword = passwordEncoder.encode(request.getPassword());

        // 5. Map request to domain entity
        User user = registerMapper.toEntity(request, encodedPassword);

        // Check if pre-registration verification token is valid
        boolean emailPreVerified = false;
        boolean phonePreVerified = false;
        if (request.getVerificationToken() != null && !request.getVerificationToken().isBlank()) {
            if (normalizedEmail != null && verificationService.isContactVerified(normalizedEmail, request.getVerificationToken())) {
                emailPreVerified = true;
                user.setEmailVerified(true);
            }
            if (normalizedPhone != null && verificationService.isContactVerified(normalizedPhone, request.getVerificationToken())) {
                phonePreVerified = true;
                user.setPhoneVerified(true);
            }
        }

        // 6. Persist user with database constraint safety
        User savedUser;
        try {
            savedUser = registerRepository.save(user);
        } catch (DataIntegrityViolationException ex) {
            log.warn("Database unique constraint violation during registration: {}", ex.getMessage());
            throw new DuplicateResourceException("A user with the specified email, username, or phone number already exists.");
        }

        log.info("New user registered successfully with ID: {}, Username: {}", savedUser.getId(), savedUser.getUsername());

        // 7. Trigger OTP verification generation only if not pre-verified
        try {
            if (!emailPreVerified && savedUser.getEmail() != null && !savedUser.getEmail().isBlank()) {
                verificationService.sendEmailVerificationOtp(savedUser);
            }
            if (!phonePreVerified && savedUser.getPhoneNumber() != null && !savedUser.getPhoneNumber().isBlank()) {
                verificationService.sendPhoneVerificationOtp(savedUser);
            }
        } catch (Exception ex) {
            log.error("Failed to send initial verification OTPs for user {}: {}", savedUser.getId(), ex.getMessage());
        }

        // 8. Generate authenticated JWT and refresh token for immediate dashboard access
        String accessToken = jwtService.generateToken(savedUser);
        com.lifeuse.auth.token.models.RefreshToken refreshToken = tokenService.createRefreshToken(savedUser);
        long expiresIn = jwtService.getJwtExpirationMs() / 1000;

        return registerMapper.toResponse(savedUser, accessToken, refreshToken.getToken(), expiresIn);
    }
}
