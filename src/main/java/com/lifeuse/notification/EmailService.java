package com.lifeuse.notification;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class EmailService implements IEmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    @Value("${app.mail.enabled:false}")
    private boolean mailEnabled;

    @Value("${app.mail.from:noreply@authapp.com}")
    private String mailFrom;

    private final com.lifeuse.notification.provider.EmailOtpProvider emailOtpProvider;

    public EmailService(com.lifeuse.notification.provider.EmailOtpProvider emailOtpProvider) {
        this.emailOtpProvider = emailOtpProvider;
    }

    @Override
    public void sendVerificationEmail(String toEmail, String otpCode) {
        emailOtpProvider.sendOtp(toEmail, otpCode, "Email Verification");
    }

    @Override
    public void sendPasswordResetEmail(String toEmail, String resetToken) {
        if (!mailEnabled) {
            log.info("[DEV MODE] Password reset token simulation for {}: [Token: {}] (Mail sending disabled)", toEmail, resetToken);
            return;
        }
        log.info("Sending password reset email to {} from {}", toEmail, mailFrom);
    }
}
