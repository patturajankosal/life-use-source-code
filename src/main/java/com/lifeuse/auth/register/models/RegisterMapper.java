package com.lifeuse.auth.register.models;

import com.lifeuse.user.models.Role;
import com.lifeuse.user.models.User;
import org.springframework.stereotype.Component;

@Component
public class RegisterMapper {

    public User toEntity(RegisterRequest request, String encodedPassword) {
        if (request == null) {
            return null;
        }
        String username = request.getUsername() != null ? request.getUsername().trim() : "";
        String email = request.getEmail() != null ? request.getEmail().trim().toLowerCase() : "";
        String phone = request.getPhoneNumber() != null ? request.getPhoneNumber().trim() : "";
        String firstName = request.getFirstName() != null ? request.getFirstName().trim() : "";
        String lastName = request.getLastName() != null ? request.getLastName().trim() : "";

        User user = new User(username, firstName, lastName, email, phone, encodedPassword, Role.ROLE_USER);
        user.setEmailVerified(false);
        user.setPhoneVerified(false);
        user.setEnabled(true);
        return user;
    }

    public RegisterResponse toResponse(User user) {
        if (user == null) {
            return null;
        }
        return new RegisterResponse(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getPhoneNumber(),
                user.isEmailVerified(),
                user.isPhoneVerified()
        );
    }
}
