package com.lifeuse.auth.verification.models;

public class VerificationResponse {

    private String identifier;
    private String type;
    private boolean verified;
    private String message;
    private String verificationToken;

    public VerificationResponse() {
    }

    public VerificationResponse(String identifier, String type, boolean verified, String message) {
        this(identifier, type, verified, message, null);
    }

    public VerificationResponse(String identifier, String type, boolean verified, String message, String verificationToken) {
        this.identifier = identifier;
        this.type = type;
        this.verified = verified;
        this.message = message;
        this.verificationToken = verificationToken;
    }

    public VerificationResponse(boolean verified, String message, String identifier, OtpType otpType) {
        this(identifier, otpType != null ? otpType.name() : null, verified, message, null);
    }

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean isVerified() {
        return verified;
    }

    public void setVerified(boolean verified) {
        this.verified = verified;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getVerificationToken() {
        return verificationToken;
    }

    public void setVerificationToken(String verificationToken) {
        this.verificationToken = verificationToken;
    }
}
