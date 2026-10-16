package com.lifeuse.user.controller;

import com.lifeuse.AppRoutes;
import com.lifeuse.common.ApiResponse;
import com.lifeuse.user.models.User;
import com.lifeuse.user.service.IUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@Tag(name = "User", description = "User profile endpoints")
public class UserController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(UserController.class);

    private final IUserService userService;

    public UserController(IUserService userService) {
        this.userService = userService;
    }

    /**
     * GET /api/v1/user/me -> UserController.getCurrentUser()
     */
    @GetMapping(AppRoutes.User.GET_ME)
    @Operation(summary = "Get current authenticated user profile", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ApiResponse<Map<String, Object>>> getCurrentUser(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            User user = (User) userService.loadUserByUsername(userDetails.getUsername());
            Map<String, Object> profile = Map.of(
                    "id",            user.getId(),
                    "username",      user.getUsername(),
                    "firstName",     user.getFirstName(),
                    "lastName",      user.getLastName(),
                    "email",         user.getEmail(),
                    "phoneNumber",   user.getPhoneNumber(),
                    "role",          user.getRole().name(),
                    "emailVerified", user.isEmailVerified(),
                    "phoneVerified", user.isPhoneVerified()
            );
            log.success("User", "Profile fetched for user '{}'", user.getUsername());
            return ApiResponse.ok("User profile retrieved successfully", profile);
        } catch (Exception ex) {
            log.error("User", "Failed to retrieve user profile for '{}': {}", userDetails != null ? userDetails.getUsername() : "null", ex.getMessage());
            throw ex;
        }
    }
}
