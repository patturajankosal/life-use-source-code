package com.lifeuse.common.utility;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneId;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("DateUtils Unit Tests")
class DateUtilsTest {

    @Test
    @DisplayName("Should accurately detect leap years")
    void testIsLeapYear() {
        assertTrue(DateUtils.isLeapYear(2024));
        assertTrue(DateUtils.isLeapYear(2000));
        assertFalse(DateUtils.isLeapYear(2026));
        assertFalse(DateUtils.isLeapYear(2100));
        assertFalse(DateUtils.isLeapYear(1900));
    }

    @Test
    @DisplayName("Should clamp day of month to valid month end, including February leap years")
    void testClampToMonthEnd() {
        // February in non-leap year (2026) clamped to 28
        LocalDate nonLeapFeb = DateUtils.clampToMonthEnd(YearMonth.of(2026, 2), 31);
        assertEquals(LocalDate.of(2026, 2, 28), nonLeapFeb);

        // February in leap year (2024) clamped to 29
        LocalDate leapFeb = DateUtils.clampToMonthEnd(YearMonth.of(2024, 2), 31);
        assertEquals(LocalDate.of(2024, 2, 29), leapFeb);

        // 30-day month (April) clamped to 30
        LocalDate aprilEnd = DateUtils.clampToMonthEnd(YearMonth.of(2026, 4), 31);
        assertEquals(LocalDate.of(2026, 4, 30), aprilEnd);

        // Within range day is preserved
        LocalDate midMonth = DateUtils.clampToMonthEnd(YearMonth.of(2026, 10), 15);
        assertEquals(LocalDate.of(2026, 10, 15), midMonth);

        // Negative or zero day clamped to 1
        LocalDate startMonth = DateUtils.clampToMonthEnd(YearMonth.of(2026, 10), 0);
        assertEquals(LocalDate.of(2026, 10, 1), startMonth);
    }

    @Test
    @DisplayName("Should construct clamped date correctly using year, month, and day")
    void testClampedDate() {
        LocalDate date = DateUtils.clampedDate(2026, 2, 30);
        assertEquals(LocalDate.of(2026, 2, 28), date);

        LocalDate validDate = DateUtils.clampedDate(2026, 8, 15);
        assertEquals(LocalDate.of(2026, 8, 15), validDate);
    }

    @Test
    @DisplayName("Should calculate inclusive days between two dates")
    void testDaysBetweenInclusive() {
        assertEquals(1, DateUtils.daysBetweenInclusive(LocalDate.of(2026, 10, 1), LocalDate.of(2026, 10, 1)));
        assertEquals(10, DateUtils.daysBetweenInclusive(LocalDate.of(2026, 10, 1), LocalDate.of(2026, 10, 10)));
        assertEquals(0, DateUtils.daysBetweenInclusive(LocalDate.of(2026, 10, 10), LocalDate.of(2026, 10, 1)));
        assertEquals(0, DateUtils.daysBetweenInclusive(null, LocalDate.of(2026, 10, 10)));
        assertEquals(0, DateUtils.daysBetweenInclusive(LocalDate.of(2026, 10, 1), null));
    }

    @Test
    @DisplayName("Should convert between LocalDate and UTC Instant safely")
    void testInstantAndLocalDateConversions() {
        LocalDate date = LocalDate.of(2026, 10, 12);
        ZoneId kolkata = ZoneId.of("Asia/Kolkata");

        Instant startInstant = DateUtils.toUtcInstant(date, kolkata);
        assertNotNull(startInstant);

        LocalDate convertedDate = DateUtils.toLocalDate(startInstant, kolkata);
        assertEquals(date, convertedDate);

        assertNull(DateUtils.toUtcInstant(null, kolkata));
        assertNull(DateUtils.toLocalDate(null, kolkata));
    }

    @Test
    @DisplayName("Should resolve ZoneId with safe fallback to Asia/Kolkata")
    void testResolveZoneId() {
        assertEquals(ZoneId.of("UTC"), DateUtils.resolveZoneId("UTC"));
        assertEquals(ZoneId.of("Asia/Kolkata"), DateUtils.resolveZoneId("Asia/Kolkata"));
        assertEquals(ZoneId.of("Asia/Kolkata"), DateUtils.resolveZoneId(null));
        assertEquals(ZoneId.of("Asia/Kolkata"), DateUtils.resolveZoneId("   "));
        assertEquals(ZoneId.of("Asia/Kolkata"), DateUtils.resolveZoneId("Invalid/Timezone_Name"));
    }
}
