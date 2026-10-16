package com.lifeuse.auth.token.controller;

import com.lifeuse.AppRoutes;
import com.lifeuse.auth.token.models.RefreshTokenRequest;
import com.lifeuse.auth.token.models.RefreshTokenResponse;
import com.lifeuse.auth.token.service.ITokenService;
import com.lifeuse.common.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "Auth — Token", description = "Refresh access token and logout (revoke refresh token)")
public class TokenController {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(TokenController.class);

    private final ITokenService tokenService;

    public TokenController(ITokenService tokenService) {
        this.tokenService = tokenService;
    }

    /**
     * POST /api/v1/auth/token/refresh -> TokenController.refreshToken()
     */
    @PostMapping(AppRoutes.Auth.POST_REFRESH_TOKEN)
    @Operation(summary = "Exchange valid refresh token for new access token")
    public ResponseEntity<ApiResponse<RefreshTokenResponse>> refreshToken(@Valid @RequestBody RefreshTokenRequest request) {
        try {
            RefreshTokenResponse response = tokenService.refreshToken(request);
            log.success("Token", "Access token refreshed");
            return ApiResponse.ok("Access token refreshed successfully", response);
        } catch (Exception ex) {
            log.error("Token", "Refresh token failed: {}", ex.getMessage());
            throw ex;
        }
    }

    /**
     * POST /api/v1/auth/token/logout -> TokenController.logout()
     */
    @PostMapping(AppRoutes.Auth.POST_LOGOUT)
    @Operation(summary = "Logout by revoking the refresh token")
    public ResponseEntity<ApiResponse<Void>> logout(@Valid @RequestBody RefreshTokenRequest request) {
        try {
            tokenService.revokeToken(request.getRefreshToken());
            log.info("Token", "Refresh token revoked — user logged out");
            return ApiResponse.ok("User logged out successfully");
        } catch (Exception ex) {
            log.error("Token", "Logout failed: {}", ex.getMessage());
            throw ex;
        }
    }
}
