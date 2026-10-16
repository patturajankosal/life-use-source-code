package com.lifeuse.common.correlation;

import com.lifeuse.common.constants.CommonConstants;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.slf4j.MDC;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import java.io.IOException;
import java.util.concurrent.atomic.AtomicReference;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("CorrelationIdFilter Diagnostic Tracing Tests")
class CorrelationIdFilterTest {

    private final CorrelationIdFilter filter = new CorrelationIdFilter();

    @Test
    @DisplayName("Should generate correlation ID when header is absent and clean up MDC after chain")
    void shouldGenerateCorrelationIdWhenHeaderAbsent() throws ServletException, IOException {
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();

        AtomicReference<String> mdcDuringExecution = new AtomicReference<>();
        FilterChain chain = (req, res) -> {
            mdcDuringExecution.set(MDC.get(CommonConstants.CORRELATION_ID_MDC_KEY));
        };

        filter.doFilter(request, response, chain);

        String generatedId = response.getHeader(CommonConstants.CORRELATION_ID_HEADER);
        assertNotNull(generatedId);
        assertFalse(generatedId.isBlank());
        assertEquals(generatedId, mdcDuringExecution.get());
        assertEquals(generatedId, request.getAttribute(CommonConstants.CORRELATION_ID_MDC_KEY));
        // MDC must be cleaned up in finally block
        assertNull(MDC.get(CommonConstants.CORRELATION_ID_MDC_KEY));
    }

    @Test
    @DisplayName("Should propagate existing correlation ID from incoming request")
    void shouldPropagateExistingCorrelationId() throws ServletException, IOException {
        String existingId = "client-trace-12345";
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader(CommonConstants.CORRELATION_ID_HEADER, existingId);
        MockHttpServletResponse response = new MockHttpServletResponse();

        AtomicReference<String> mdcDuringExecution = new AtomicReference<>();
        FilterChain chain = (req, res) -> {
            mdcDuringExecution.set(MDC.get(CommonConstants.CORRELATION_ID_MDC_KEY));
        };

        filter.doFilter(request, response, chain);

        assertEquals(existingId, response.getHeader(CommonConstants.CORRELATION_ID_HEADER));
        assertEquals(existingId, mdcDuringExecution.get());
        assertNull(MDC.get(CommonConstants.CORRELATION_ID_MDC_KEY));
    }
}
