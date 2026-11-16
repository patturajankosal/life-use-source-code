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

    private final com.lifeuse.notification.provider.SmsOtpProvider smsOtpProvider;

    public SmsService(com.lifeuse.notification.provider.SmsOtpProvider smsOtpProvider) {
        this.smsOtpProvider = smsOtpProvider;
    }

    @Override
    public void sendOtpSms(String phoneNumber, String otpCode) {
        smsOtpProvider.sendOtp(phoneNumber, otpCode, "Phone Verification");
    }
}
