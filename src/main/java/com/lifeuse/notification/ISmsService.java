package com.lifeuse.notification;

public interface ISmsService {

    void sendOtpSms(String phoneNumber, String otpCode);
}
