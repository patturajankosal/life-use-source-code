package com.lifeuse.auth.login;

import com.lifeuse.AppRoutes;
import com.lifeuse.auth.login.controller.LoginController;
import com.lifeuse.auth.login.models.LoginRequest;
import com.lifeuse.auth.login.models.LoginResponse;
import com.lifeuse.auth.login.service.ILoginService;
import com.lifeuse.common.GlobalExceptionHandler;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
@DisplayName("LoginController Unit Tests")
class LoginControllerTest {

    private MockMvc mockMvc;

    private ObjectMapper objectMapper;

    @Mock
    private ILoginService loginService;

    @InjectMocks
    private LoginController loginController;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        mockMvc = MockMvcBuilders.standaloneSetup(loginController)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
    }

    @Test
    @DisplayName("POST /api/v1/auth/login - Should successfully return 200 OK and LoginResponse")
    void shouldReturn200OnSuccessfulLogin() throws Exception {
        LoginRequest request = new LoginRequest("user_one", "password123");
        LoginResponse response = new LoginResponse(
                "mockAccessToken",
                "mockRefreshToken",
                "Bearer",
                900L,
                10L,
                "user_one",
                "user@example.com",
                "User",
                "One",
                "+1234567890",
                "ROLE_USER",
                true,
                true
        );

        when(loginService.login(any(LoginRequest.class))).thenReturn(response);

        mockMvc.perform(post(AppRoutes.Auth.POST_LOGIN)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.message").value("Login successful"))
                .andExpect(jsonPath("$.data.accessToken").value("mockAccessToken"))
                .andExpect(jsonPath("$.data.refreshToken").value("mockRefreshToken"))
                .andExpect(jsonPath("$.data.userId").value(10))
                .andExpect(jsonPath("$.data.username").value("user_one"))
                .andExpect(jsonPath("$.data.email").value("user@example.com"));
    }

    @Test
    @DisplayName("POST /api/v1/auth/login - Should return 401 Unauthorized on invalid credentials")
    void shouldReturn401OnBadCredentials() throws Exception {
        LoginRequest request = new LoginRequest("invalid_user", "wrong_pwd");

        when(loginService.login(any(LoginRequest.class)))
                .thenThrow(new BadCredentialsException("Invalid username or password"));

        mockMvc.perform(post(AppRoutes.Auth.POST_LOGIN)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.message").value("Invalid login credentials"));
    }

    @Test
    @DisplayName("POST /api/v1/auth/login - Should return 400 Bad Request on blank identifier")
    void shouldReturn400OnValidationFailure() throws Exception {
        LoginRequest request = new LoginRequest("", "");

        mockMvc.perform(post(AppRoutes.Auth.POST_LOGIN)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.data.identifier").exists())
                .andExpect(jsonPath("$.data.password").exists());
    }
}
