package com.lifeuse.common;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("ApiResponse Enterprise Architecture Tests")
class ApiResponseTest {

    @Test
    @DisplayName("Should construct success payload with message and data")
    void shouldConstructSuccessPayload() {
        ApiResponse<String> response = ApiResponse.success("Operation successful", "Test Payload");

        assertTrue(response.isSuccess());
        assertEquals("Operation successful", response.getMessage());
        assertEquals("Test Payload", response.getData());
        assertNotNull(response.getTimestamp());
        assertNull(response.getErrorCode());
    }

    @Test
    @DisplayName("Should construct success payload with message only")
    void shouldConstructSuccessPayloadMessageOnly() {
        ApiResponse<Void> response = ApiResponse.success("Operation successful");

        assertTrue(response.isSuccess());
        assertEquals("Operation successful", response.getMessage());
        assertNull(response.getData());
    }

    @Test
    @DisplayName("Should construct success payload with data only")
    void shouldConstructSuccessPayloadDataOnly() {
        ApiResponse<Integer> response = ApiResponse.success(42);

        assertTrue(response.isSuccess());
        assertEquals("Operation completed successfully", response.getMessage());
        assertEquals(42, response.getData());
    }

    @Test
    @DisplayName("Should construct failure payload with errorCode and message")
    void shouldConstructFailurePayload() {
        ApiResponse<Void> response = ApiResponse.failure(ApiResponse.ErrorCode.INVALID_CREDENTIALS, "Bad credentials");

        assertFalse(response.isSuccess());
        assertEquals("Bad credentials", response.getMessage());
        assertEquals(ApiResponse.ErrorCode.INVALID_CREDENTIALS, response.getErrorCode());
        assertNull(response.getData());
        assertNotNull(response.getTimestamp());
    }

    @Test
    @DisplayName("Should construct error payload with message only")
    void shouldConstructErrorPayloadMessageOnly() {
        ApiResponse<Void> response = ApiResponse.error("Generic error");

        assertFalse(response.isSuccess());
        assertEquals("Generic error", response.getMessage());
        assertEquals(ApiResponse.ErrorCode.INTERNAL_SERVER_ERROR, response.getErrorCode());
    }

    @Test
    @DisplayName("Should build ResponseEntity with HTTP 200 OK and success payload")
    void shouldBuildOkResponseEntity() {
        ResponseEntity<ApiResponse<String>> entity = ApiResponse.ok("Success", "MyData");

        assertEquals(HttpStatus.OK, entity.getStatusCode());
        assertNotNull(entity.getBody());
        assertTrue(entity.getBody().isSuccess());
        assertEquals("Success", entity.getBody().getMessage());
        assertEquals("MyData", entity.getBody().getData());
    }

    @Test
    @DisplayName("Should build ResponseEntity with HTTP 200 OK and message only")
    void shouldBuildOkResponseEntityMessageOnly() {
        ResponseEntity<ApiResponse<Void>> entity = ApiResponse.ok("All done");

        assertEquals(HttpStatus.OK, entity.getStatusCode());
        assertNotNull(entity.getBody());
        assertTrue(entity.getBody().isSuccess());
        assertEquals("All done", entity.getBody().getMessage());
    }

    @Test
    @DisplayName("Should build ResponseEntity with HTTP 201 Created")
    void shouldBuildCreatedResponseEntity() {
        ResponseEntity<ApiResponse<Integer>> entity = ApiResponse.created("Resource created", 101);

        assertEquals(HttpStatus.CREATED, entity.getStatusCode());
        assertNotNull(entity.getBody());
        assertTrue(entity.getBody().isSuccess());
        assertEquals(101, entity.getBody().getData());
    }

    @Test
    @DisplayName("Should build ResponseEntity with custom status")
    void shouldBuildCustomStatusResponseEntity() {
        ResponseEntity<ApiResponse<String>> entity = ApiResponse.status(HttpStatus.ACCEPTED, "Accepted processing", "Task-1");

        assertEquals(HttpStatus.ACCEPTED, entity.getStatusCode());
        assertNotNull(entity.getBody());
        assertTrue(entity.getBody().isSuccess());
        assertEquals("Accepted processing", entity.getBody().getMessage());
        assertEquals("Task-1", entity.getBody().getData());
    }

    @Test
    @DisplayName("Should build error ResponseEntity with errorCode and field-level data")
    void shouldBuildErrorResponseEntityWithData() {
        Map<String, String> fieldErrors = Map.of("email", "Email is invalid");
        ResponseEntity<ApiResponse<Map<String, String>>> entity =
                ApiResponse.error(HttpStatus.BAD_REQUEST, ApiResponse.ErrorCode.VALIDATION_FAILED, "Validation failed", fieldErrors);

        assertEquals(HttpStatus.BAD_REQUEST, entity.getStatusCode());
        assertNotNull(entity.getBody());
        assertFalse(entity.getBody().isSuccess());
        assertEquals("Validation failed", entity.getBody().getMessage());
        assertEquals(ApiResponse.ErrorCode.VALIDATION_FAILED, entity.getBody().getErrorCode());
        assertEquals("Email is invalid", entity.getBody().getData().get("email"));
    }

    @Test
    @DisplayName("Should build error ResponseEntity with HTTP status and message only")
    void shouldBuildErrorResponseEntityStatusAndMessage() {
        ResponseEntity<ApiResponse<Void>> entity = ApiResponse.error(HttpStatus.BAD_REQUEST, "Bad Request occurred");

        assertEquals(HttpStatus.BAD_REQUEST, entity.getStatusCode());
        assertNotNull(entity.getBody());
        assertFalse(entity.getBody().isSuccess());
        assertEquals("Bad Request occurred", entity.getBody().getMessage());
        assertEquals(ApiResponse.ErrorCode.INTERNAL_SERVER_ERROR, entity.getBody().getErrorCode());
    }

    @Test
    @DisplayName("Should test ApiLog structured logger methods")
    void shouldTestApiLog() {
        ApiResponse.ApiLog log = ApiResponse.ApiLog.of(ApiResponseTest.class);
        assertNotNull(log);

        // Verify that logging does not throw exceptions
        assertDoesNotThrow(() -> {
            log.success("TestModule", "Testing success log with id: {}", 1);
            log.success("Testing success log without module tag: {}", 2);
            log.error("TestModule", "Testing error log with code: {}", "ERR_01");
            log.error("Testing error log without module tag: {}", "ERR_02");
            log.error("TestModule", "Testing exception log", new RuntimeException("Test err"));
            log.warn("TestModule", "Testing warn log: {}", "warning details");
            log.warn("Testing warn log without module tag");
            log.info("TestModule", "Testing info log: {}", "info details");
            log.info("Testing info log without module tag");
        });
    }

    @Test
    @DisplayName("Should have all expected ErrorCode constants defined")
    void shouldHaveAllExpectedErrorCodes() {
        assertNotNull(ApiResponse.ErrorCode.INVALID_CREDENTIALS);
        assertNotNull(ApiResponse.ErrorCode.ACCOUNT_DISABLED);
        assertNotNull(ApiResponse.ErrorCode.ACCOUNT_LOCKED);
        assertNotNull(ApiResponse.ErrorCode.EMAIL_ALREADY_EXISTS);
        assertNotNull(ApiResponse.ErrorCode.PHONE_ALREADY_EXISTS);
        assertNotNull(ApiResponse.ErrorCode.USERNAME_ALREADY_EXISTS);
        assertNotNull(ApiResponse.ErrorCode.INVALID_OTP);
        assertNotNull(ApiResponse.ErrorCode.EXPIRED_OTP);
        assertNotNull(ApiResponse.ErrorCode.INVALID_REFRESH_TOKEN);
        assertNotNull(ApiResponse.ErrorCode.EXPIRED_REFRESH_TOKEN);
        assertNotNull(ApiResponse.ErrorCode.VALIDATION_FAILED);
        assertNotNull(ApiResponse.ErrorCode.RESOURCE_NOT_FOUND);
        assertNotNull(ApiResponse.ErrorCode.INTERNAL_SERVER_ERROR);
    }
}
