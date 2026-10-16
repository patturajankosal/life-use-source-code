package com.lifeuse.notification;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class SmsService implements ISmsService {

    private static final Logger log = LoggerFactory.getLogger(SmsService.class);

    @Value("${app.sms.enabled:false}")
    private boolean smsEnabled;

    @Value("${app.sms.sender-id:AUTHAPP}")
    private String senderId;

    @Override
    public void sendOtpSms(String phoneNumber, String otpCode) {
        if (!smsEnabled) {
            log.info("[DEV MODE] SMS OTP simulation for {}: [Code: {}] (SMS sending disabled)", phoneNumber, otpCode);
            return;
        }
        // In production with SMS provider enabled, Twilio / AWS SNS / Infobip API call is triggered here.
        log.info("Sending SMS OTP to {} with Sender ID {}", phoneNumber, senderId);
    }
}
