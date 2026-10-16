package com.lifeuse.auth.verification.models;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class ResendOtpRequest {

    @NotBlank(message = "Identifier (email or phone number) is required")
    private String identifier;

    @NotNull(message = "OTP type is required (EMAIL or PHONE)")
    private OtpType type;

    public ResendOtpRequest() {
    }

    public ResendOtpRequest(String identifier, OtpType type) {
        this.identifier = identifier;
        this.type = type;
    }

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public OtpType getType() {
        return type;
    }

    public void setType(OtpType type) {
        this.type = type;
    }
}
