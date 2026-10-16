package com.lifeuse.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lifeuse.common.ApiResponse;
import com.lifeuse.common.correlation.CorrelationIdFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint {

    private final ObjectMapper objectMapper;

    public JwtAuthenticationEntryPoint(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @Override
    public void commence(HttpServletRequest request,
                         HttpServletResponse response,
                         AuthenticationException authException) throws IOException {
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setStatus(HttpStatus.UNAUTHORIZED.value());

        String path = request != null ? request.getRequestURI() : null;
        String correlationId = CorrelationIdFilter.getCurrentCorrelationId();

        ApiResponse<Void> apiResponse = new ApiResponse<>(
                false,
                ApiResponse.ErrorCode.AUTHENTICATION_REQUIRED,
                "Full authentication is required to access this resource",
                null,
                path,
                correlationId
        );
        response.getWriter().write(objectMapper.writeValueAsString(apiResponse));
    }
}
