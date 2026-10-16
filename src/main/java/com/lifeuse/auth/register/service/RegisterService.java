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

    public RegisterService(IRegisterRepository registerRepository,
                           RegisterMapper registerMapper,
                           PasswordEncoder passwordEncoder,
                           IVerificationService verificationService) {
        this.registerRepository = registerRepository;
        this.registerMapper = registerMapper;
        this.passwordEncoder = passwordEncoder;
        this.verificationService = verificationService;
    }

    @Override
    @Transactional
    public RegisterResponse register(RegisterRequest request) {
        // 1. Password confirmation check
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new BusinessException("Password and confirm password do not match");
        }

        // 2. Normalize inputs
        String normalizedEmail = request.getEmail().trim().toLowerCase();
        String normalizedUsername = request.getUsername().trim();
        String normalizedPhone = request.getPhoneNumber().trim();

        // 3. Pre-check uniqueness across all three unique identifiers
        if (registerRepository.existsByEmail(normalizedEmail)) {
            throw new DuplicateResourceException(String.format("An account with email '%s' already exists.", normalizedEmail));
        }
        if (registerRepository.existsByUsername(normalizedUsername)) {
            throw new DuplicateResourceException(String.format("An account with username '%s' already exists.", normalizedUsername));
        }
        if (registerRepository.existsByPhoneNumber(normalizedPhone)) {
            throw new DuplicateResourceException(String.format("An account with phone number '%s' already exists.", normalizedPhone));
        }

        // 4. Hash password securely
        String encodedPassword = passwordEncoder.encode(request.getPassword());

        // 5. Map request to domain entity
        User user = registerMapper.toEntity(request, encodedPassword);

        // 6. Persist user with database constraint safety
        User savedUser;
        try {
            savedUser = registerRepository.save(user);
        } catch (DataIntegrityViolationException ex) {
            log.warn("Database unique constraint violation during registration: {}", ex.getMessage());
            throw new DuplicateResourceException("A user with the specified email, username, or phone number already exists.");
        }

        log.info("New user registered successfully with ID: {}, Username: {}", savedUser.getId(), savedUser.getUsername());

        // 7. Trigger OTP verification generation
        try {
            verificationService.sendEmailVerificationOtp(savedUser);
            verificationService.sendPhoneVerificationOtp(savedUser);
        } catch (Exception ex) {
            log.error("Failed to send initial verification OTPs for user {}: {}", savedUser.getId(), ex.getMessage());
        }

        return registerMapper.toResponse(savedUser);
    }
}
