package com.lifeuse.notification;

public interface IEmailService {

    void sendVerificationEmail(String toEmail, String otpCode);

    void sendPasswordResetEmail(String toEmail, String resetToken);
}
