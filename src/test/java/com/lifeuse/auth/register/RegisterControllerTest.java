package com.lifeuse.auth.register;

import com.lifeuse.AppRoutes;
import com.lifeuse.auth.register.controller.RegisterController;
import com.lifeuse.auth.register.models.RegisterRequest;
import com.lifeuse.auth.register.models.RegisterResponse;
import com.lifeuse.auth.register.service.IRegisterService;
import com.lifeuse.common.DuplicateResourceException;
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
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
@DisplayName("RegisterController Unit Tests")
class RegisterControllerTest {

    private MockMvc mockMvc;

    private ObjectMapper objectMapper;

    @Mock
    private IRegisterService registerService;

    @InjectMocks
    private RegisterController registerController;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        mockMvc = MockMvcBuilders.standaloneSetup(registerController)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
    }

    @Test
    @DisplayName("POST /api/v1/auth/register - Should return 201 Created on successful registration")
    void shouldReturn201OnSuccessfulRegistration() throws Exception {
        RegisterRequest request = new RegisterRequest(
                "john_doe", "John", "Doe", "john@example.com", "+1234567890", "Secret123!", "Secret123!"
        );
        RegisterResponse response = new RegisterResponse(
                1L, "john_doe", "john@example.com", "+1234567890", false, false
        );

        when(registerService.register(any(RegisterRequest.class))).thenReturn(response);

        mockMvc.perform(post(AppRoutes.Auth.POST_REGISTER)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.username").value("john_doe"))
                .andExpect(jsonPath("$.data.email").value("john@example.com"));
    }

    @Test
    @DisplayName("POST /api/v1/auth/register - Should return 409 Conflict when unique field duplicate")
    void shouldReturn409OnDuplicateUser() throws Exception {
        RegisterRequest request = new RegisterRequest(
                "john_doe", "John", "Doe", "john@example.com", "+1234567890", "Secret123!", "Secret123!"
        );

        when(registerService.register(any(RegisterRequest.class)))
                .thenThrow(new DuplicateResourceException("An account with email 'john@example.com' already exists."));

        mockMvc.perform(post(AppRoutes.Auth.POST_REGISTER)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.message").value("An account with email 'john@example.com' already exists."));
    }

    @Test
    @DisplayName("POST /api/v1/auth/register - Should return 400 Bad Request on invalid fields")
    void shouldReturn400OnValidationFailure() throws Exception {
        RegisterRequest request = new RegisterRequest("", "", "", "", "");

        mockMvc.perform(post(AppRoutes.Auth.POST_REGISTER)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.data.email").exists())
                .andExpect(jsonPath("$.data.username").exists());
    }
}
