package com.lifeuse.auth.login.models;

import com.lifeuse.user.models.User;
import org.springframework.stereotype.Component;

@Component
public class LoginMapper {

    public LoginResponse toResponse(User user, String accessToken, String refreshToken, long expiresIn) {
        if (user == null) {
            return null;
        }
        return new LoginResponse(
                accessToken,
                refreshToken,
                "Bearer",
                expiresIn,
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getFirstName(),
                user.getLastName(),
                user.getPhoneNumber(),
                user.getRole() != null ? user.getRole().name() : "ROLE_USER",
                user.isEmailVerified(),
                user.isPhoneVerified()
        );
    }
}
