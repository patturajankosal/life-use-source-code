package com.lifeuse.common;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.time.Instant;

/**
 * ============================================================
 * LIFEUSE — ENTERPRISE API RESPONSE ARCHITECTURE
 * ============================================================
 * Single reusable common file for unified response handling and
 * enterprise structured logging across all modules and controllers.
 *
 * 1. ApiResponse<T> — standardized JSON response structure
 * 2. ErrorCode      — centralized catalog of business & API error codes
 * 3. ApiLog         — unified structured logger (log.success, log.error, log.warn, log.info)
 *
 * JSON Structure:
 * {
 *   "success":   true | false,
 *   "errorCode": "INVALID_CREDENTIALS",   // populated on errors only
 *   "message":   "Human-readable status or error description",
 *   "data":      { ... },                 // payload (omitted if null)
 *   "timestamp": "2026-10-11T12:00:00Z"
 * }
 * ============================================================
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {

    // =========================================================================
    // RESPONSE FIELDS
    // =========================================================================

    private boolean success;
    private String errorCode;     // null on success — populated on errors only
    private String message;
    private T data;
    private Instant timestamp;
    private String path;          // request URI — null if not set
    private String correlationId; // request tracing ID — null if not set

    // =========================================================================
    // CONSTRUCTORS
    // =========================================================================

    public ApiResponse() {
        this.timestamp = Instant.now();
    }

    public ApiResponse(boolean success, String message, T data) {
        this.success = success;
        this.errorCode = null;
        this.message = message;
        this.data = data;
        this.timestamp = Instant.now();
    }

    public ApiResponse(boolean success, String errorCode, String message, T data) {
        this.success = success;
        this.errorCode = errorCode;
        this.message = message;
        this.data = data;
        this.timestamp = Instant.now();
    }

    public ApiResponse(boolean success, String errorCode, String message, T data, Instant timestamp) {
        this.success = success;
        this.errorCode = errorCode;
        this.message = message;
        this.data = data;
        this.timestamp = timestamp;
    }

    public ApiResponse(boolean success, String errorCode, String message, T data, String path, String correlationId) {
        this.success = success;
        this.errorCode = errorCode;
        this.message = message;
        this.data = data;
        this.timestamp = Instant.now();
        this.path = path;
        this.correlationId = correlationId;
    }

    // =========================================================================
    // ERROR CODE CATALOG
    // Enterprise error codes cataloged in one reusable location
    // =========================================================================

    public static final class ErrorCode {

        private ErrorCode() {}

        // Auth & Login
        public static final String INVALID_CREDENTIALS        = "INVALID_CREDENTIALS";
        public static final String ACCOUNT_DISABLED           = "ACCOUNT_DISABLED";
        public static final String ACCOUNT_LOCKED             = "ACCOUNT_LOCKED";

        // Registration
        public static final String EMAIL_ALREADY_EXISTS       = "EMAIL_ALREADY_EXISTS";
        public static final String PHONE_ALREADY_EXISTS       = "PHONE_ALREADY_EXISTS";
        public static final String USERNAME_ALREADY_EXISTS    = "USERNAME_ALREADY_EXISTS";

        // OTP & Verification
        public static final String INVALID_OTP                = "INVALID_OTP";
        public static final String EXPIRED_OTP                = "EXPIRED_OTP";
        public static final String OTP_ALREADY_VERIFIED       = "OTP_ALREADY_VERIFIED";
        public static final String OTP_MAX_ATTEMPTS_EXCEEDED  = "OTP_MAX_ATTEMPTS_EXCEEDED";

        // Password Management
        public static final String INVALID_RESET_TOKEN        = "INVALID_RESET_TOKEN";
        public static final String EXPIRED_RESET_TOKEN        = "EXPIRED_RESET_TOKEN";
        public static final String CURRENT_PASSWORD_MISMATCH  = "CURRENT_PASSWORD_MISMATCH";
        public static final String PASSWORD_SAME_AS_OLD       = "PASSWORD_SAME_AS_OLD";

        // Token & Session
        public static final String INVALID_REFRESH_TOKEN      = "INVALID_REFRESH_TOKEN";
        public static final String EXPIRED_REFRESH_TOKEN      = "EXPIRED_REFRESH_TOKEN";
        public static final String TOKEN_REVOKED              = "TOKEN_REVOKED";

        // Common & System
        public static final String VALIDATION_FAILED          = "VALIDATION_FAILED";
        public static final String VALIDATION_ERROR           = "VALIDATION_ERROR";
        public static final String RESOURCE_NOT_FOUND         = "RESOURCE_NOT_FOUND";
        public static final String ACCESS_DENIED              = "ACCESS_DENIED";
        public static final String AUTHENTICATION_REQUIRED    = "AUTHENTICATION_REQUIRED";
        public static final String DUPLICATE_RESOURCE         = "DUPLICATE_RESOURCE";
        public static final String INTERNAL_SERVER_ERROR      = "INTERNAL_SERVER_ERROR";
        public static final String BAD_REQUEST                = "BAD_REQUEST";
        public static final String BUSINESS_RULE_VIOLATION    = "BUSINESS_RULE_VIOLATION";
        public static final String DATABASE_ERROR             = "DATABASE_ERROR";
        public static final String DATABASE_CONSTRAINT_VIOLATION = "DATABASE_CONSTRAINT_VIOLATION";
        public static final String SERVICE_UNAVAILABLE        = "SERVICE_UNAVAILABLE";
        public static final String TOKEN_EXPIRED              = "TOKEN_EXPIRED";

        // Money Manager
        public static final String PROFILE_NOT_FOUND          = "PROFILE_NOT_FOUND";
        public static final String INVALID_AMOUNT             = "INVALID_AMOUNT";
        public static final String INSUFFICIENT_FUNDS         = "INSUFFICIENT_FUNDS";
        public static final String CATEGORY_NOT_FOUND         = "CATEGORY_NOT_FOUND";
        public static final String BUDGET_PLAN_NOT_FOUND      = "BUDGET_PLAN_NOT_FOUND";
        public static final String BUDGET_OVERSPENT           = "BUDGET_OVERSPENT";
        public static final String PLANNED_EXPENSE_NOT_FOUND  = "PLANNED_EXPENSE_NOT_FOUND";
        public static final String SCHEDULE_NOT_FOUND         = "SCHEDULE_NOT_FOUND";
        public static final String INVALID_DATE_RANGE         = "INVALID_DATE_RANGE";
        public static final String DUPLICATE_TRANSACTION      = "DUPLICATE_TRANSACTION";
        public static final String COMMITMENT_NOT_FOUND       = "COMMITMENT_NOT_FOUND";
    }

    // =========================================================================
    // PAYLOAD BUILDERS (Direct ApiResponse<T> objects)
    // =========================================================================

    /** Success payload with message + data */
    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(true, null, message, data);
    }

    /** Success payload with message only */
    public static <T> ApiResponse<T> success(String message) {
        return new ApiResponse<>(true, null, message, null);
    }

    /** Success payload with data only and standard message */
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, null, "Operation completed successfully", data);
    }

    /** Error payload with errorCode + message */
    public static <T> ApiResponse<T> failure(String errorCode, String message) {
        return new ApiResponse<>(false, errorCode, message, null);
    }

    /** Error payload with errorCode + message + data */
    public static <T> ApiResponse<T> failure(String errorCode, String message, T data) {
        return new ApiResponse<>(false, errorCode, message, data);
    }

    /** Error payload with message only (defaults to INTERNAL_SERVER_ERROR code) */
    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(false, ErrorCode.INTERNAL_SERVER_ERROR, message, null);
    }

    /** Error payload with errorCode + message */
    public static <T> ApiResponse<T> error(String errorCode, String message) {
        return new ApiResponse<>(false, errorCode, message, null);
    }

    /** Error payload with errorCode + message + data */
    public static <T> ApiResponse<T> error(String errorCode, String message, T data) {
        return new ApiResponse<>(false, errorCode, message, data);
    }

    // =========================================================================
    // RESPONSE ENTITY BUILDERS (Standardized Controller Return Values)
    // =========================================================================

    // --- Success (HTTP 200 OK) ---

    public static <T> ResponseEntity<ApiResponse<T>> ok(String message, T data) {
        return ResponseEntity.ok(success(message, data));
    }

    public static <T> ResponseEntity<ApiResponse<T>> ok(String message) {
        return ResponseEntity.ok(success(message));
    }

    public static <T> ResponseEntity<ApiResponse<T>> ok(T data) {
        return ResponseEntity.ok(success(data));
    }

    // --- Created (HTTP 201 Created) ---

    public static <T> ResponseEntity<ApiResponse<T>> created(String message, T data) {
        return ResponseEntity.status(HttpStatus.CREATED).body(success(message, data));
    }

    public static <T> ResponseEntity<ApiResponse<T>> created(String message) {
        return ResponseEntity.status(HttpStatus.CREATED).body(success(message));
    }

    // --- Custom Status ---

    public static <T> ResponseEntity<ApiResponse<T>> status(HttpStatus status, String message, T data) {
        return ResponseEntity.status(status).body(success(message, data));
    }

    public static <T> ResponseEntity<ApiResponse<T>> status(HttpStatus status, String message) {
        return ResponseEntity.status(status).body(success(message));
    }

    // --- Error Responses ---

    public static <T> ResponseEntity<ApiResponse<T>> error(HttpStatus status, String errorCode, String message) {
        return ResponseEntity.status(status).body(failure(errorCode, message));
    }

    public static <T> ResponseEntity<ApiResponse<T>> error(HttpStatus status, String errorCode, String message, T data) {
        return ResponseEntity.status(status).body(failure(errorCode, message, data));
    }

    public static <T> ResponseEntity<ApiResponse<T>> error(HttpStatus status, String message) {
        return ResponseEntity.status(status).body(failure(ErrorCode.INTERNAL_SERVER_ERROR, message));
    }

    public static <T> ResponseEntity<ApiResponse<T>> error(HttpStatus status, String errorCode, String message, T data, String path, String correlationId) {
        ApiResponse<T> resp = new ApiResponse<>(false, errorCode, message, data, path, correlationId);
        return ResponseEntity.status(status).body(resp);
    }

    // =========================================================================
    // ApiLog — REUSABLE ENTERPRISE STRUCTURED LOGGER
    // =========================================================================
    //
    // Usage:
    //   private static final ApiResponse.ApiLog log = ApiResponse.ApiLog.of(LoginController.class);
    //
    //   log.success("Login", "User {} logged in", userId);
    //   log.error("Login", "Invalid credentials for {}", identifier);
    //   log.warn("Register", "Duplicate account attempt: {}", email);
    //   log.info("Token", "Refresh token issued for {}", userId);
    //
    // Or without module tag:
    //   log.success("Operation succeeded for id: {}", id);
    //   log.error("Failed to process request: {}", ex.getMessage());
    // =========================================================================

    public static final class ApiLog {

        private static final String SUCCESS_PREFIX = "[{}] [SUCCESS] ";
        private static final String ERROR_PREFIX   = "[{}] [ERROR] ";
        private static final String WARN_PREFIX    = "[{}] [WARN] ";
        private static final String INFO_PREFIX    = "[{}] [INFO] ";

        private final Logger logger;
        private final String defaultModule;

        private ApiLog(Class<?> clazz) {
            this.logger = LoggerFactory.getLogger(clazz);
            this.defaultModule = clazz.getSimpleName();
        }

        public static ApiLog of(Class<?> clazz) {
            return new ApiLog(clazz);
        }

        // --- SUCCESS ---

        public void success(String module, String message) {
            logger.info(SUCCESS_PREFIX + message, module);
        }

        public void success(String module, String message, Object arg) {
            logger.info(SUCCESS_PREFIX + message, module, arg);
        }

        public void success(String module, String message, Object arg1, Object arg2) {
            logger.info(SUCCESS_PREFIX + message, module, arg1, arg2);
        }

        public void success(String module, String message, Object... args) {
            Object[] combined = prepend(module, args);
            logger.info(SUCCESS_PREFIX + message, combined);
        }

        public void success(String message, Object... args) {
            Object[] combined = prepend(defaultModule, args);
            logger.info(SUCCESS_PREFIX + message, combined);
        }

        // --- ERROR ---

        public void error(String module, String message) {
            logger.error(ERROR_PREFIX + message, module);
        }

        public void error(String module, String message, Object arg) {
            logger.error(ERROR_PREFIX + message, module, arg);
        }

        public void error(String module, String message, Object arg1, Object arg2) {
            logger.error(ERROR_PREFIX + message, module, arg1, arg2);
        }

        public void error(String module, String message, Object... args) {
            Object[] combined = prepend(module, args);
            logger.error(ERROR_PREFIX + message, combined);
        }

        public void error(String module, String message, Throwable throwable) {
            logger.error(ERROR_PREFIX + message, module, throwable);
        }

        public void error(String message, Object... args) {
            Object[] combined = prepend(defaultModule, args);
            logger.error(ERROR_PREFIX + message, combined);
        }

        public void error(String message, Throwable throwable) {
            logger.error(ERROR_PREFIX + message, defaultModule, throwable);
        }

        // --- WARN ---

        public void warn(String module, String message) {
            logger.warn(WARN_PREFIX + message, module);
        }

        public void warn(String module, String message, Object arg) {
            logger.warn(WARN_PREFIX + message, module, arg);
        }

        public void warn(String module, String message, Object... args) {
            Object[] combined = prepend(module, args);
            logger.warn(WARN_PREFIX + message, combined);
        }

        public void warn(String message, Object... args) {
            Object[] combined = prepend(defaultModule, args);
            logger.warn(WARN_PREFIX + message, combined);
        }

        // --- INFO ---

        public void info(String module, String message) {
            logger.info(INFO_PREFIX + message, module);
        }

        public void info(String module, String message, Object arg) {
            logger.info(INFO_PREFIX + message, module, arg);
        }

        public void info(String module, String message, Object... args) {
            Object[] combined = prepend(module, args);
            logger.info(INFO_PREFIX + message, combined);
        }

        public void info(String message, Object... args) {
            Object[] combined = prepend(defaultModule, args);
            logger.info(INFO_PREFIX + message, combined);
        }

        // --- Internal Helper ---

        private static Object[] prepend(Object first, Object[] rest) {
            if (rest == null || rest.length == 0) {
                return new Object[]{first};
            }
            Object[] combined = new Object[rest.length + 1];
            combined[0] = first;
            System.arraycopy(rest, 0, combined, 1, rest.length);
            return combined;
        }
    }

    // =========================================================================
    // GETTERS AND SETTERS
    // =========================================================================

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public Instant getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Instant timestamp) {
        this.timestamp = timestamp;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getCorrelationId() {
        return correlationId;
    }

    public void setCorrelationId(String correlationId) {
        this.correlationId = correlationId;
    }
}
