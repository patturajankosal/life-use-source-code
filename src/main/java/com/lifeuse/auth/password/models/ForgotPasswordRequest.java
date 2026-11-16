package com.lifeuse.auth.password.models;

public class ForgotPasswordRequest {

    private String email;
    private String identifier;

    public ForgotPasswordRequest() {
    }

    public ForgotPasswordRequest(String identifierOrEmail) {
        if (identifierOrEmail != null && identifierOrEmail.contains("@")) {
            this.email = identifierOrEmail;
        }
        this.identifier = identifierOrEmail;
    }

    public String getEmail() {
        return email != null ? email : identifier;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getIdentifier() {
        return identifier != null ? identifier : email;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }
}
