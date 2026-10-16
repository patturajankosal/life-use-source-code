package com.lifeuse.auth.verification.service;

import com.lifeuse.auth.verification.models.EmailVerificationRequest;
import com.lifeuse.auth.verification.models.PhoneVerificationRequest;
import com.lifeuse.auth.verification.models.ResendOtpRequest;
import com.lifeuse.auth.verification.models.VerificationResponse;
import com.lifeuse.user.models.User;

public interface IVerificationService {

    VerificationResponse verifyEmail(EmailVerificationRequest request);

    VerificationResponse verifyPhone(PhoneVerificationRequest request);

    VerificationResponse resendOtp(ResendOtpRequest request);

    void createAndSendEmailOtp(User user);

    void createAndSendPhoneOtp(User user);

    void sendEmailVerificationOtp(User user);

    void sendPhoneVerificationOtp(User user);
}
