package com.lifeuse.auth.register.models;

public class RegisterResponse {

    private Long id;
    private String username;
    private String email;
    private String phoneNumber;
    private boolean emailVerified;
    private boolean phoneVerified;

    public RegisterResponse() {
    }

    public RegisterResponse(Long id, String username, String email, String phoneNumber, boolean emailVerified, boolean phoneVerified) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.emailVerified = emailVerified;
        this.phoneVerified = phoneVerified;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    public void setEmailVerified(boolean emailVerified) {
        this.emailVerified = emailVerified;
    }

    public boolean isPhoneVerified() {
        return phoneVerified;
    }

    public void setPhoneVerified(boolean phoneVerified) {
        this.phoneVerified = phoneVerified;
    }
}
