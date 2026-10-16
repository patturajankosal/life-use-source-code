package com.lifeuse.common.utility;

import com.lifeuse.common.constants.CommonConstants;

import java.time.*;
import java.time.temporal.ChronoUnit;

public final class DateUtils {

    private DateUtils() {
        // Prevent instantiation
    }

    /**
     * Determines if a given year is a leap year.
     */
    public static boolean isLeapYear(int year) {
        return Year.isLeap(year);
    }

    /**
     * Clamps a day-of-month (e.g. 31) to the actual maximum length of the specified year and month.
     * E.g. 31 clamped to Feb 2024 returns 29; clamped to Feb 2025 returns 28; clamped to Apr returns 30.
     */
    public static int clampToMonthEnd(int year, int month, int targetDay) {
        YearMonth ym = YearMonth.of(year, month);
        int maxDays = ym.lengthOfMonth();
        return Math.min(Math.max(1, targetDay), maxDays);
    }

    /**
     * Clamps targetDay to targetYearMonth length, returning a LocalDate.
     */
    public static LocalDate clampToMonthEnd(YearMonth yearMonth, int targetDay) {
        return clampedDate(yearMonth, targetDay);
    }

    /**
     * Clamps targetDay to targetYearMonth length.
     */
    public static LocalDate clampedDate(YearMonth yearMonth, int targetDay) {
        int maxDays = yearMonth.lengthOfMonth();
        int day = Math.min(Math.max(1, targetDay), maxDays);
        return yearMonth.atDay(day);
    }

    /**
     * Clamps targetDay for given year and month.
     */
    public static LocalDate clampedDate(int year, int month, int targetDay) {
        return clampedDate(YearMonth.of(year, month), targetDay);
    }

    /**
     * Returns the count of days between start and end date inclusive.
     * Returns 0 if either date is null or if start is after end.
     */
    public static long daysBetweenInclusive(LocalDate start, LocalDate end) {
        if (start == null || end == null) return 0L;
        if (end.isBefore(start)) return 0L;
        return ChronoUnit.DAYS.between(start, end) + 1L;
    }

    /**
     * Start of day at UTC instant.
     */
    public static Instant startOfDayUtc(LocalDate date) {
        if (date == null) return Instant.now();
        return date.atStartOfDay(ZoneOffset.UTC).toInstant();
    }

    /**
     * End of day at UTC instant (exclusive bound for end of day queries, i.e., start of next day).
     */
    public static Instant endOfDayUtc(LocalDate date) {
        if (date == null) return Instant.now();
        return date.plusDays(1).atStartOfDay(ZoneOffset.UTC).toInstant();
    }

    /**
     * Start of month in UTC.
     */
    public static Instant startOfMonthUtc(YearMonth month) {
        if (month == null) month = YearMonth.now();
        return month.atDay(1).atStartOfDay(ZoneOffset.UTC).toInstant();
    }

    /**
     * End of month boundary in UTC (start of first day of next month).
     */
    public static Instant endOfMonthUtc(YearMonth month) {
        if (month == null) month = YearMonth.now();
        return month.atEndOfMonth().plusDays(1).atStartOfDay(ZoneOffset.UTC).toInstant();
    }

    /**
     * Converts a local date to UTC Instant using the user's specific ZoneId.
     */
    public static Instant toUtcInstant(LocalDate date, ZoneId zoneId) {
        if (date == null) return null;
        ZoneId zone = zoneId != null ? zoneId : CommonConstants.DEFAULT_ZONE_ID;
        return date.atStartOfDay(zone).toInstant();
    }

    /**
     * Converts an Instant to LocalDate in the user's configured ZoneId.
     */
    public static LocalDate toLocalDate(Instant instant, ZoneId zoneId) {
        if (instant == null) return null;
        ZoneId zone = zoneId != null ? zoneId : CommonConstants.DEFAULT_ZONE_ID;
        return instant.atZone(zone).toLocalDate();
    }

    /**
     * Safely resolves a ZoneId from a timezone string with fallback to default (Asia/Kolkata).
     */
    public static ZoneId resolveZoneId(String timezoneStr) {
        if (timezoneStr == null || timezoneStr.isBlank()) {
            return CommonConstants.DEFAULT_ZONE_ID;
        }
        try {
            return ZoneId.of(timezoneStr.trim());
        } catch (Exception e) {
            return CommonConstants.DEFAULT_ZONE_ID;
        }
    }
}
