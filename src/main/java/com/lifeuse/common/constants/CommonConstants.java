package com.lifeuse.common.constants;

import java.math.RoundingMode;
import java.time.ZoneId;
import java.time.ZoneOffset;

public final class CommonConstants {

    private CommonConstants() {
        // Prevent instantiation
    }

    // --- Currency & Financial Precision ---
    public static final String DEFAULT_CURRENCY = "INR";
    public static final int DEFAULT_MONEY_SCALE = 2;
    public static final RoundingMode DEFAULT_ROUNDING_MODE = RoundingMode.HALF_UP;

    // --- Date & Time ---
    public static final String DEFAULT_TIMEZONE_ID = "Asia/Kolkata";
    public static final ZoneId DEFAULT_ZONE_ID = ZoneId.of(DEFAULT_TIMEZONE_ID);
    public static final ZoneOffset UTC_OFFSET = ZoneOffset.UTC;

    // --- Tracing & Correlation ---
    public static final String CORRELATION_ID_HEADER = "X-Correlation-ID";
    public static final String CORRELATION_ID_MDC_KEY = "correlationId";

    // --- Pagination Defaults ---
    public static final int DEFAULT_PAGE_LIMIT = 50;
    public static final int MAX_PAGE_LIMIT = 200;
}
