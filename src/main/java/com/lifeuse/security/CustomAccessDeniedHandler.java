package com.lifeuse.security;

import com.lifeuse.common.ApiResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lifeuse.common.correlation.CorrelationIdFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

    private final ObjectMapper objectMapper;

    public CustomAccessDeniedHandler(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @Override
    public void handle(HttpServletRequest request,
                       HttpServletResponse response,
                       AccessDeniedException accessDeniedException) throws IOException {
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setStatus(HttpStatus.FORBIDDEN.value());

        String path = request != null ? request.getRequestURI() : null;
        String correlationId = CorrelationIdFilter.getCurrentCorrelationId();

        ApiResponse<Void> apiResponse = new ApiResponse<>(
                false,
                ApiResponse.ErrorCode.ACCESS_DENIED,
                "Access is denied for the requested resource",
                null,
                path,
                correlationId
        );
        response.getWriter().write(objectMapper.writeValueAsString(apiResponse));
    }
}
