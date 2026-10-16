package com.lifeuse.common;

import com.lifeuse.common.correlation.CorrelationIdFilter;
import com.lifeuse.common.exception.DatabaseOperationException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.util.HashMap;
import java.util.Map;

/**
 * Centralized exception handler for all REST controllers.
 * Maps every exception type to a standardized ApiResponse with an errorCode,
 * request path, and developer correlationId.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(GlobalExceptionHandler.class);

    private String resolvePath() {
        RequestAttributes attrs = RequestContextHolder.getRequestAttributes();
        if (attrs instanceof ServletRequestAttributes sra) {
            HttpServletRequest req = sra.getRequest();
            return req != null ? req.getRequestURI() : null;
        }
        return null;
    }

    private String resolveCorrelationId() {
        return CorrelationIdFilter.getCurrentCorrelationId();
    }

    private <T> ResponseEntity<ApiResponse<T>> buildError(HttpStatus status, String errorCode, String message, T data) {
        return ApiResponse.error(status, errorCode, message, data, resolvePath(), resolveCorrelationId());
    }

    private ResponseEntity<ApiResponse<Void>> buildError(HttpStatus status, String errorCode, String message) {
        return ApiResponse.error(status, errorCode, message, null, resolvePath(), resolveCorrelationId());
    }

    // ── Validation ────────────────────────────────────────────────────────────

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Map<String, String>>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> fieldErrors = new HashMap<>();
        for (FieldError error : ex.getBindingResult().getFieldErrors()) {
            fieldErrors.put(error.getField(), error.getDefaultMessage());
        }
        log.warn("Validation", "Request validation failed: {}", fieldErrors);
        return buildError(HttpStatus.BAD_REQUEST, ApiResponse.ErrorCode.VALIDATION_FAILED, "Validation failed", fieldErrors);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleConstraintViolation(ConstraintViolationException ex) {
        log.warn("Validation", "Constraint violation: {}", ex.getMessage());
        return buildError(HttpStatus.BAD_REQUEST, ApiResponse.ErrorCode.VALIDATION_FAILED, ex.getMessage());
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiResponse<Void>> handleHttpMessageNotReadable(HttpMessageNotReadableException ex) {
        log.warn("Request", "Malformed JSON body: {}", ex.getMessage());
        return buildError(HttpStatus.BAD_REQUEST, ApiResponse.ErrorCode.BAD_REQUEST, "Malformed JSON request body");
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ApiResponse<Void>> handleTypeMismatch(MethodArgumentTypeMismatchException ex) {
        log.warn("Request", "Parameter type mismatch for '{}': {}", ex.getName(), ex.getMessage());
        return buildError(HttpStatus.BAD_REQUEST, ApiResponse.ErrorCode.BAD_REQUEST, "Invalid request parameter value for: " + ex.getName());
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ApiResponse<Void>> handleMissingParameter(MissingServletRequestParameterException ex) {
        log.warn("Request", "Missing required parameter: {}", ex.getParameterName());
        return buildError(HttpStatus.BAD_REQUEST, ApiResponse.ErrorCode.BAD_REQUEST, "Required request parameter is missing: " + ex.getParameterName());
    }

    // ── Business / Domain ─────────────────────────────────────────────────────

    @ExceptionHandler(DuplicateResourceException.class)
    public ResponseEntity<ApiResponse<Void>> handleDuplicateResource(DuplicateResourceException ex) {
        log.warn("Business", "Duplicate resource: {}", ex.getMessage());
        return buildError(HttpStatus.CONFLICT, ApiResponse.ErrorCode.DUPLICATE_RESOURCE, ex.getMessage());
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleResourceNotFound(ResourceNotFoundException ex) {
        log.warn("Business", "Resource not found: {}", ex.getMessage());
        return buildError(HttpStatus.NOT_FOUND, ApiResponse.ErrorCode.RESOURCE_NOT_FOUND, ex.getMessage());
    }

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(BusinessException ex) {
        log.warn("Business", "Business rule violation: {}", ex.getMessage());
        String code = ex.getErrorCode() != null ? ex.getErrorCode() : ApiResponse.ErrorCode.BAD_REQUEST;
        return buildError(HttpStatus.BAD_REQUEST, code, ex.getMessage());
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiResponse<Void>> handleIllegalArgumentException(IllegalArgumentException ex) {
        log.warn("Validation", "Illegal argument: {}", ex.getMessage());
        return buildError(HttpStatus.BAD_REQUEST, ApiResponse.ErrorCode.BAD_REQUEST, ex.getMessage());
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<ApiResponse<Void>> handleIllegalStateException(IllegalStateException ex) {
        log.warn("Business", "Illegal state: {}", ex.getMessage());
        return buildError(HttpStatus.BAD_REQUEST, ApiResponse.ErrorCode.BAD_REQUEST, ex.getMessage());
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ApiResponse<Void>> handleMethodNotSupported(HttpRequestMethodNotSupportedException ex) {
        log.warn("Request", "Method not supported: {}", ex.getMessage());
        return buildError(HttpStatus.METHOD_NOT_ALLOWED, ApiResponse.ErrorCode.BAD_REQUEST, ex.getMessage());
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleNoResourceFound(NoResourceFoundException ex) {
        log.warn("Request", "Resource not found: {}", ex.getMessage());
        return buildError(HttpStatus.NOT_FOUND, ApiResponse.ErrorCode.RESOURCE_NOT_FOUND, "Resource not found: " + ex.getResourcePath());
    }

    // ── Database Layer ────────────────────────────────────────────────────────

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleDataIntegrityViolation(DataIntegrityViolationException ex) {
        log.warn("Database", "Data integrity violation: {}", ex.getMessage());
        return buildError(HttpStatus.CONFLICT, ApiResponse.ErrorCode.DUPLICATE_RESOURCE,
                "A user with the specified email, username, or phone number already exists.");
    }

    @ExceptionHandler(DatabaseOperationException.class)
    public ResponseEntity<ApiResponse<Void>> handleDatabaseOperationException(DatabaseOperationException ex) {
        log.error("Database", "Database operation failed: {}", ex.getMessage(), ex);
        return buildError(HttpStatus.INTERNAL_SERVER_ERROR, ApiResponse.ErrorCode.DATABASE_ERROR,
                "Unable to complete the database operation. Please try again later.");
    }

    @ExceptionHandler(DataAccessException.class)
    public ResponseEntity<ApiResponse<Void>> handleDataAccessException(DataAccessException ex) {
        log.error("Database", "Low-level database access exception: {}", ex.getMessage(), ex);
        return buildError(HttpStatus.INTERNAL_SERVER_ERROR, ApiResponse.ErrorCode.DATABASE_ERROR,
                "Unable to complete the database operation. Please try again later.");
    }

    // ── Authentication / Authorization ────────────────────────────────────────

    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ApiResponse<Void>> handleBadCredentials(BadCredentialsException ex) {
        log.warn("Auth", "Authentication failed — invalid credentials");
        return buildError(HttpStatus.UNAUTHORIZED, ApiResponse.ErrorCode.INVALID_CREDENTIALS, "Invalid login credentials");
    }

    @ExceptionHandler(DisabledException.class)
    public ResponseEntity<ApiResponse<Void>> handleDisabledAccount(DisabledException ex) {
        log.warn("Auth", "Authentication failed — account disabled");
        return buildError(HttpStatus.FORBIDDEN, ApiResponse.ErrorCode.ACCOUNT_DISABLED,
                "Account is disabled. Please verify your email/phone or contact support.");
    }

    @ExceptionHandler(LockedException.class)
    public ResponseEntity<ApiResponse<Void>> handleLockedAccount(LockedException ex) {
        log.warn("Auth", "Authentication failed — account locked");
        return buildError(HttpStatus.FORBIDDEN, ApiResponse.ErrorCode.ACCOUNT_LOCKED,
                "Account is locked. Please reset your password or contact support.");
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiResponse<Void>> handleAccessDenied(AccessDeniedException ex) {
        log.warn("Auth", "Access denied: {}", ex.getMessage());
        return buildError(HttpStatus.FORBIDDEN, ApiResponse.ErrorCode.ACCESS_DENIED, "Access is denied");
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ApiResponse<Void>> handleAuthenticationException(AuthenticationException ex) {
        log.warn("Auth", "Authentication exception: {}", ex.getMessage());
        return buildError(HttpStatus.UNAUTHORIZED, ApiResponse.ErrorCode.AUTHENTICATION_REQUIRED,
                "Authentication is required to access this resource");
    }

    // ── Catch-All ─────────────────────────────────────────────────────────────

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGenericException(Exception ex) {
        log.error("System", "Unhandled exception occurred", ex);
        return buildError(HttpStatus.INTERNAL_SERVER_ERROR, ApiResponse.ErrorCode.INTERNAL_SERVER_ERROR,
                "An unexpected internal server error occurred");
    }
}
