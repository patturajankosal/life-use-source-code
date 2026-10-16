package com.lifeuse.auth.login.controller;

import com.lifeuse.AppRoutes;
import com.lifeuse.auth.login.models.LoginRequest;
import com.lifeuse.auth.login.models.LoginResponse;
import com.lifeuse.auth.login.service.ILoginService;
import com.lifeuse.common.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "Auth — Login", description = "Authenticate user and obtain access + refresh tokens")
public class LoginController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(LoginController.class);

    private final ILoginService loginService;

    public LoginController(ILoginService loginService) {
        this.loginService = loginService;
    }

    /**
     * POST /api/v1/auth/login -> LoginController.login()
     */
    @PostMapping(AppRoutes.Auth.POST_LOGIN)
    @Operation(summary = "Login with username, email, or phone number")
    public ResponseEntity<ApiResponse<LoginResponse>> login(@Valid @RequestBody LoginRequest request) {
        try {
            LoginResponse response = loginService.login(request);
            log.success("Login", "User '{}' authenticated successfully", request.getIdentifier());
            return ApiResponse.ok("Login successful", response);
        } catch (Exception ex) {
            log.error("Login", "Login failed for identifier '{}': {}", request.getIdentifier(), ex.getMessage());
            throw ex;
        }
    }
}
