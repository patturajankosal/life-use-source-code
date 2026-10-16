package com.lifeuse.auth.register.controller;

import com.lifeuse.AppRoutes;
import com.lifeuse.auth.register.models.RegisterRequest;
import com.lifeuse.auth.register.models.RegisterResponse;
import com.lifeuse.auth.register.service.IRegisterService;
import com.lifeuse.common.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "Auth — Register", description = "Register a new user account")
public class RegisterController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(RegisterController.class);

    private final IRegisterService registerService;

    public RegisterController(IRegisterService registerService) {
        this.registerService = registerService;
    }

    /**
     * POST /api/v1/auth/register -> RegisterController.register()
     */
    @PostMapping(AppRoutes.Auth.POST_REGISTER)
    @Operation(summary = "Register a new user with email, phone, username and password")
    public ResponseEntity<ApiResponse<RegisterResponse>> register(@Valid @RequestBody RegisterRequest request) {
        try {
            RegisterResponse response = registerService.register(request);
            log.success("Register", "New user registered — username: '{}'", request.getUsername());
            return ApiResponse.created("User registered successfully. Please verify your email and phone number.", response);
        } catch (Exception ex) {
            log.error("Register", "Registration failed for username '{}': {}", request.getUsername(), ex.getMessage());
            throw ex;
        }
    }
}
