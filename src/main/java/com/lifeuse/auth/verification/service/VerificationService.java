package com.lifeuse.auth.verification.service;

import com.lifeuse.auth.verification.models.EmailVerificationRequest;
import com.lifeuse.auth.verification.models.OtpType;
import com.lifeuse.auth.verification.models.OtpVerification;
import com.lifeuse.auth.verification.models.PhoneVerificationRequest;
import com.lifeuse.auth.verification.models.ResendOtpRequest;
import com.lifeuse.auth.verification.models.VerificationResponse;
import com.lifeuse.auth.verification.repository.IVerificationRepository;
import com.lifeuse.common.BusinessException;
import com.lifeuse.common.ResourceNotFoundException;
import com.lifeuse.common.OtpGenerator;
import com.lifeuse.notification.IEmailService;
import com.lifeuse.notification.ISmsService;
import com.lifeuse.user.models.User;
import com.lifeuse.user.repository.IUserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.temporal.ChronoUnit;

@Service
public class VerificationService implements IVerificationService {

    private final IVerificationRepository otpRepository;
    private final IUserRepository userRepository;
    private final IEmailService emailService;
    private final ISmsService smsService;

    @Value("${app.otp.expiration-minutes:10}")
    private int otpExpirationMinutes;

    @Value("${app.otp.max-attempts:5}")
    private int maxAttempts;

    public VerificationService(IVerificationRepository otpRepository,
                               IUserRepository userRepository,
                               IEmailService emailService,
                               ISmsService smsService) {
        this.otpRepository = otpRepository;
        this.userRepository = userRepository;
        this.emailService = emailService;
        this.smsService = smsService;
    }

    @Override
    @Transactional
    public void createAndSendEmailOtp(User user) {
        String code = OtpGenerator.generateOtp();
        Instant expiresAt = Instant.now().plus(otpExpirationMinutes, ChronoUnit.MINUTES);
        OtpVerification otp = new OtpVerification(user, code, OtpType.EMAIL, expiresAt);
        otpRepository.save(otp);
        emailService.sendVerificationEmail(user.getEmail(), code);
    }

    @Override
    @Transactional
    public void createAndSendPhoneOtp(User user) {
        String code = OtpGenerator.generateOtp();
        Instant expiresAt = Instant.now().plus(otpExpirationMinutes, ChronoUnit.MINUTES);
        OtpVerification otp = new OtpVerification(user, code, OtpType.PHONE, expiresAt);
        otpRepository.save(otp);
        smsService.sendOtpSms(user.getPhoneNumber(), code);
    }

    @Override
    @Transactional
    public void sendEmailVerificationOtp(User user) {
        createAndSendEmailOtp(user);
    }

    @Override
    @Transactional
    public void sendPhoneVerificationOtp(User user) {
        createAndSendPhoneOtp(user);
    }

    @Override
    @Transactional
    public VerificationResponse verifyEmail(EmailVerificationRequest request) {
        String email = request.getEmail().trim().toLowerCase();
        java.util.Optional<User> optionalUser = userRepository.findByEmail(email);

        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            if (user.isEmailVerified()) {
                return new VerificationResponse(user.getEmail(), "EMAIL", true, "Email is already verified");
            }

            OtpVerification otp = otpRepository.findTopByUserAndTypeAndVerifiedFalseOrderByCreatedAtDesc(user, OtpType.EMAIL)
                    .orElseGet(() -> otpRepository.findTopByIdentifierAndTypeAndVerifiedFalseOrderByCreatedAtDesc(email, OtpType.EMAIL)
                            .orElseThrow(() -> new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.RESOURCE_NOT_FOUND, "No active OTP found. Please request a new verification code.")));

            validateOtp(otp, request.getOtpCode());

            String token = java.util.UUID.randomUUID().toString();
            otp.setVerified(true);
            otp.setToken(token);
            otpRepository.save(otp);

            user.setEmailVerified(true);
            userRepository.save(user);

            return new VerificationResponse(user.getEmail(), "EMAIL", true, "Email verified successfully", token);
        }

        // New User Pre-Registration Flow
        OtpVerification otp = otpRepository.findTopByIdentifierAndTypeAndVerifiedFalseOrderByCreatedAtDesc(email, OtpType.EMAIL)
                .orElseThrow(() -> new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.RESOURCE_NOT_FOUND, "No active OTP found. Please request a new verification code."));

        validateOtp(otp, request.getOtpCode());

        String token = java.util.UUID.randomUUID().toString();
        otp.setVerified(true);
        otp.setToken(token);
        otpRepository.save(otp);

        return new VerificationResponse(email, "EMAIL", true, "Email verified successfully", token);
    }

    @Override
    @Transactional
    public VerificationResponse verifyPhone(PhoneVerificationRequest request) {
        String phone = request.getPhoneNumber().trim();
        java.util.Optional<User> optionalUser = userRepository.findByPhoneNumber(phone);

        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            if (user.isPhoneVerified()) {
                return new VerificationResponse(user.getPhoneNumber(), "PHONE", true, "Phone number is already verified");
            }

            OtpVerification otp = otpRepository.findTopByUserAndTypeAndVerifiedFalseOrderByCreatedAtDesc(user, OtpType.PHONE)
                    .orElseGet(() -> otpRepository.findTopByIdentifierAndTypeAndVerifiedFalseOrderByCreatedAtDesc(phone, OtpType.PHONE)
                            .orElseThrow(() -> new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.RESOURCE_NOT_FOUND, "No active OTP found. Please request a new verification code.")));

            validateOtp(otp, request.getOtpCode());

            String token = java.util.UUID.randomUUID().toString();
            otp.setVerified(true);
            otp.setToken(token);
            otpRepository.save(otp);

            user.setPhoneVerified(true);
            userRepository.save(user);

            return new VerificationResponse(user.getPhoneNumber(), "PHONE", true, "Phone number verified successfully", token);
        }

        // New User Pre-Registration Flow
        OtpVerification otp = otpRepository.findTopByIdentifierAndTypeAndVerifiedFalseOrderByCreatedAtDesc(phone, OtpType.PHONE)
                .orElseThrow(() -> new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.RESOURCE_NOT_FOUND, "No active OTP found. Please request a new verification code."));

        validateOtp(otp, request.getOtpCode());

        String token = java.util.UUID.randomUUID().toString();
        otp.setVerified(true);
        otp.setToken(token);
        otpRepository.save(otp);

        return new VerificationResponse(phone, "PHONE", true, "Phone number verified successfully", token);
    }

    @Override
    @Transactional
    public VerificationResponse resendOtp(ResendOtpRequest request) {
        String identifier = request.getIdentifier().trim();

        if (request.getType() == OtpType.EMAIL) {
            String email = identifier.toLowerCase();
            java.util.Optional<User> optionalUser = userRepository.findByEmail(email);

            if (optionalUser.isPresent()) {
                User user = optionalUser.get();
                if (user.isEmailVerified()) {
                    throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.BAD_REQUEST, "Email is already verified");
                }
                createAndSendEmailOtp(user);
            } else {
                // New user registration Step 1 / Resend
                String code = OtpGenerator.generateOtp();
                Instant expiresAt = Instant.now().plus(otpExpirationMinutes, ChronoUnit.MINUTES);
                OtpVerification otp = new OtpVerification(email, code, OtpType.EMAIL, expiresAt);
                otpRepository.save(otp);
                emailService.sendVerificationEmail(email, code);
            }
        } else {
            java.util.Optional<User> optionalUser = userRepository.findByPhoneNumber(identifier);

            if (optionalUser.isPresent()) {
                User user = optionalUser.get();
                if (user.isPhoneVerified()) {
                    throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.BAD_REQUEST, "Phone number is already verified");
                }
                createAndSendPhoneOtp(user);
            } else {
                // New user registration Step 1 / Resend
                String code = OtpGenerator.generateOtp();
                Instant expiresAt = Instant.now().plus(otpExpirationMinutes, ChronoUnit.MINUTES);
                OtpVerification otp = new OtpVerification(identifier, code, OtpType.PHONE, expiresAt);
                otpRepository.save(otp);
                smsService.sendOtpSms(identifier, code);
            }
        }

        return new VerificationResponse(identifier, request.getType().name(), false, "Verification code sent successfully");
    }

    @Override
    @Transactional
    public VerificationResponse sendRegistrationOtp(String identifier, OtpType type) {
        String trimmedIdentifier = identifier.trim();
        if (type == OtpType.EMAIL) {
            String email = trimmedIdentifier.toLowerCase();
            if (userRepository.existsByEmail(email)) {
                throw new com.lifeuse.common.DuplicateResourceException("An account with this email already exists.");
            }
        } else if (type == OtpType.PHONE) {
            if (userRepository.existsByPhoneNumber(trimmedIdentifier)) {
                throw new com.lifeuse.common.DuplicateResourceException("An account with this phone number already exists.");
            }
        }
        return resendOtp(new ResendOtpRequest(trimmedIdentifier, type));
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isContactVerified(String identifier, String verificationToken) {
        if (verificationToken == null || verificationToken.isBlank() || identifier == null) {
            return false;
        }
        return otpRepository.findTopByTokenAndVerifiedTrue(verificationToken.trim())
                .map(otp -> {
                    String storedIdentifier = otp.getIdentifier();
                    if (storedIdentifier == null && otp.getUser() != null) {
                        storedIdentifier = otp.getType() == OtpType.EMAIL
                                ? otp.getUser().getEmail()
                                : otp.getUser().getPhoneNumber();
                    }
                    if (storedIdentifier == null) {
                        return false;
                    }
                    boolean matches = otp.getType() == OtpType.EMAIL
                            ? storedIdentifier.equalsIgnoreCase(identifier.trim())
                            : storedIdentifier.equals(identifier.trim());
                    boolean notExpired = otp.getCreatedAt().plus(30, ChronoUnit.MINUTES).isAfter(Instant.now());
                    return matches && notExpired;
                })
                .orElse(false);
    }

    private void validateOtp(OtpVerification otp, String providedCode) {
        if (Instant.now().isAfter(otp.getExpiresAt())) {
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.TOKEN_EXPIRED, "Verification code has expired. Please request a new one.");
        }

        if (otp.getAttempts() >= maxAttempts) {
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.BAD_REQUEST, "Maximum verification attempts exceeded. Please request a new code.");
        }

        otp.setAttempts(otp.getAttempts() + 1);

        if (!otp.getOtpCode().equals(providedCode.trim())) {
            otpRepository.save(otp);
            throw new BusinessException(com.lifeuse.common.ApiResponse.ErrorCode.VALIDATION_FAILED, "Invalid verification code");
        }
    }
}
