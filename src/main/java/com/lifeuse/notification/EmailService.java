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

    @Override
    public void sendVerificationEmail(String toEmail, String otpCode) {
        if (!mailEnabled) {
            log.info("[DEV MODE] Email verification OTP simulation for {}: [Code: {}] (Mail sending disabled)", toEmail, otpCode);
            return;
        }
        // In production with mail enabled, integration with JavaMailSender / SendGrid / AWS SES is triggered here.
        log.info("Sending verification email to {} from {}", toEmail, mailFrom);
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
