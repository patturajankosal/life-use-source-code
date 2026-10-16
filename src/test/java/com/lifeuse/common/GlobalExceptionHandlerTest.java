package com.lifeuse.common;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@DisplayName("GlobalExceptionHandler Unit Tests")
class GlobalExceptionHandlerTest {

    private GlobalExceptionHandler exceptionHandler;

    @BeforeEach
    void setUp() {
        exceptionHandler = new GlobalExceptionHandler();
    }

    @Test
    @DisplayName("Should handle DuplicateResourceException with 409 Conflict and DUPLICATE_RESOURCE error code")
    void shouldHandleDuplicateResourceException() {
        DuplicateResourceException ex = new DuplicateResourceException("Email already exists");

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleDuplicateResource(ex);

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals("Email already exists", response.getBody().getMessage());
        assertEquals(ApiResponse.ErrorCode.DUPLICATE_RESOURCE, response.getBody().getErrorCode());
    }

    @Test
    @DisplayName("Should handle DataIntegrityViolationException with 409 Conflict")
    void shouldHandleDataIntegrityViolationException() {
        DataIntegrityViolationException ex = new DataIntegrityViolationException("duplicate key value violates unique constraint");

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleDataIntegrityViolation(ex);

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals("A user with the specified email, username, or phone number already exists.", response.getBody().getMessage());
        assertEquals(ApiResponse.ErrorCode.DUPLICATE_RESOURCE, response.getBody().getErrorCode());
    }

    @Test
    @DisplayName("Should handle ResourceNotFoundException with 404 Not Found and RESOURCE_NOT_FOUND error code")
    void shouldHandleResourceNotFoundException() {
        ResourceNotFoundException ex = new ResourceNotFoundException("User", "id", 123);

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleResourceNotFound(ex);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertTrue(response.getBody().getMessage().contains("User not found with id: '123'"));
        assertEquals(ApiResponse.ErrorCode.RESOURCE_NOT_FOUND, response.getBody().getErrorCode());
    }

    @Test
    @DisplayName("Should handle BusinessException with 400 Bad Request and default BAD_REQUEST error code")
    void shouldHandleBusinessException() {
        BusinessException ex = new BusinessException("Invalid operation");

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleBusinessException(ex);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals("Invalid operation", response.getBody().getMessage());
        assertEquals(ApiResponse.ErrorCode.BAD_REQUEST, response.getBody().getErrorCode());
    }

    @Test
    @DisplayName("Should handle BusinessException with custom error code")
    void shouldHandleBusinessExceptionWithCustomErrorCode() {
        BusinessException ex = new BusinessException(ApiResponse.ErrorCode.TOKEN_EXPIRED, "Token has expired");

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleBusinessException(ex);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals("Token has expired", response.getBody().getMessage());
        assertEquals(ApiResponse.ErrorCode.TOKEN_EXPIRED, response.getBody().getErrorCode());
    }

    @Test
    @DisplayName("Should handle BadCredentialsException with 401 Unauthorized and INVALID_CREDENTIALS error code")
    void shouldHandleBadCredentialsException() {
        BadCredentialsException ex = new BadCredentialsException("Bad credentials");

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleBadCredentials(ex);

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals("Invalid login credentials", response.getBody().getMessage());
        assertEquals(ApiResponse.ErrorCode.INVALID_CREDENTIALS, response.getBody().getErrorCode());
    }

    @Test
    @DisplayName("Should handle DisabledException with 403 Forbidden and ACCOUNT_DISABLED error code")
    void shouldHandleDisabledException() {
        DisabledException ex = new DisabledException("Disabled");

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleDisabledAccount(ex);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals(ApiResponse.ErrorCode.ACCOUNT_DISABLED, response.getBody().getErrorCode());
    }

    @Test
    @DisplayName("Should handle MethodArgumentNotValidException with 400 Bad Request and field-level error map")
    void shouldHandleValidationExceptions() {
        MethodArgumentNotValidException ex = mock(MethodArgumentNotValidException.class);
        BindingResult bindingResult = mock(BindingResult.class);

        FieldError fieldError = new FieldError("registerRequest", "email", "Email is required");
        when(bindingResult.getFieldErrors()).thenReturn(List.of(fieldError));
        when(ex.getBindingResult()).thenReturn(bindingResult);

        ResponseEntity<ApiResponse<Map<String, String>>> response = exceptionHandler.handleValidationExceptions(ex);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals("Validation failed", response.getBody().getMessage());
        assertEquals(ApiResponse.ErrorCode.VALIDATION_FAILED, response.getBody().getErrorCode());
        assertEquals("Email is required", response.getBody().getData().get("email"));
    }

    @Test
    @DisplayName("Should handle DatabaseOperationException with 500 Internal Server Error and DATABASE_ERROR code")
    void shouldHandleDatabaseOperationException() {
        com.lifeuse.common.exception.DatabaseOperationException ex =
                new com.lifeuse.common.exception.DatabaseOperationException("Failed to persist record", new RuntimeException("DB down"));

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleDatabaseOperationException(ex);

        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals(ApiResponse.ErrorCode.DATABASE_ERROR, response.getBody().getErrorCode());
        assertEquals("Unable to complete the database operation. Please try again later.", response.getBody().getMessage());
    }

    @Test
    @DisplayName("Should handle IllegalArgumentException with 400 Bad Request")
    void shouldHandleIllegalArgumentException() {
        IllegalArgumentException ex = new IllegalArgumentException("Invalid date format");

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleIllegalArgumentException(ex);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals(ApiResponse.ErrorCode.BAD_REQUEST, response.getBody().getErrorCode());
        assertEquals("Invalid date format", response.getBody().getMessage());
    }

    @Test
    @DisplayName("Should handle IllegalStateException with 400 Bad Request")
    void shouldHandleIllegalStateException() {
        IllegalStateException ex = new IllegalStateException("Budget plan is already finalized");

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleIllegalStateException(ex);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals(ApiResponse.ErrorCode.BAD_REQUEST, response.getBody().getErrorCode());
        assertEquals("Budget plan is already finalized", response.getBody().getMessage());
    }

    @Test
    @DisplayName("Should handle HttpRequestMethodNotSupportedException with 405 Method Not Allowed")
    void shouldHandleMethodNotSupported() {
        org.springframework.web.HttpRequestMethodNotSupportedException ex =
                new org.springframework.web.HttpRequestMethodNotSupportedException("POST");

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleMethodNotSupported(ex);

        assertEquals(HttpStatus.METHOD_NOT_ALLOWED, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals(ApiResponse.ErrorCode.BAD_REQUEST, response.getBody().getErrorCode());
    }

    @Test
    @DisplayName("Should handle NoResourceFoundException with 404 Not Found")
    void shouldHandleNoResourceFoundException() {
        org.springframework.web.servlet.resource.NoResourceFoundException ex =
                new org.springframework.web.servlet.resource.NoResourceFoundException(org.springframework.http.HttpMethod.GET, "/api/v1/unknown");

        ResponseEntity<ApiResponse<Void>> response = exceptionHandler.handleNoResourceFound(ex);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNotNull(response.getBody());
        assertFalse(response.getBody().isSuccess());
        assertEquals(ApiResponse.ErrorCode.RESOURCE_NOT_FOUND, response.getBody().getErrorCode());
        assertTrue(response.getBody().getMessage().contains("/api/v1/unknown"));
    }
}
