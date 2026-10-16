package com.lifeuse.common;

import java.security.SecureRandom;

public final class OtpGenerator {

    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int DEFAULT_OTP_LENGTH = 6;

    private OtpGenerator() {
        // Prevent instantiation
    }

    public static String generateOtp() {
        return generateOtp(DEFAULT_OTP_LENGTH);
    }

    public static String generateOtp(int length) {
        StringBuilder otp = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            otp.append(RANDOM.nextInt(10));
        }
        return otp.toString();
    }
}
