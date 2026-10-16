package com.lifeuse.common.utility;

import com.lifeuse.common.constants.CommonConstants;

import java.math.BigDecimal;
import java.math.RoundingMode;

public final class MoneyUtils {

    private MoneyUtils() {
        // Prevent instantiation
    }

    /**
     * Normalize amount to the default money scale (2 decimal places) using HALF_UP rounding.
     * Null values are normalized to BigDecimal.ZERO with scale 2.
     */
    public static BigDecimal scale(BigDecimal amount) {
        if (amount == null) {
            return BigDecimal.ZERO.setScale(CommonConstants.DEFAULT_MONEY_SCALE, CommonConstants.DEFAULT_ROUNDING_MODE);
        }
        return amount.setScale(CommonConstants.DEFAULT_MONEY_SCALE, CommonConstants.DEFAULT_ROUNDING_MODE);
    }

    /**
     * Scale with custom precision and rounding mode.
     */
    public static BigDecimal scale(BigDecimal amount, int scale, RoundingMode roundingMode) {
        if (amount == null) {
            return BigDecimal.ZERO.setScale(scale, roundingMode);
        }
        return amount.setScale(scale, roundingMode);
    }

    /**
     * Formats amount as plain decimal string (e.g., "1250.50").
     */
    public static String format(BigDecimal amount) {
        return scale(amount).toPlainString();
    }

    /**
     * Numeric equality check using compareTo() so that scale differences do not affect equality
     * (e.g. 10.0 equals 10.00). Nulls are treated as zero.
     */
    public static boolean isEqual(BigDecimal a, BigDecimal b) {
        BigDecimal valA = a != null ? a : BigDecimal.ZERO;
        BigDecimal valB = b != null ? b : BigDecimal.ZERO;
        return valA.compareTo(valB) == 0;
    }

    /**
     * Check if a > b.
     */
    public static boolean isGreaterThan(BigDecimal a, BigDecimal b) {
        BigDecimal valA = a != null ? a : BigDecimal.ZERO;
        BigDecimal valB = b != null ? b : BigDecimal.ZERO;
        return valA.compareTo(valB) > 0;
    }

    /**
     * Check if a < b.
     */
    public static boolean isLessThan(BigDecimal a, BigDecimal b) {
        BigDecimal valA = a != null ? a : BigDecimal.ZERO;
        BigDecimal valB = b != null ? b : BigDecimal.ZERO;
        return valA.compareTo(valB) < 0;
    }

    /**
     * Checks if amount is strictly greater than zero.
     */
    public static boolean isPositive(BigDecimal amount) {
        return amount != null && amount.compareTo(BigDecimal.ZERO) > 0;
    }

    /**
     * Checks if amount is greater than or equal to zero.
     */
    public static boolean isNonNegative(BigDecimal amount) {
        return amount != null && amount.compareTo(BigDecimal.ZERO) >= 0;
    }

    /**
     * Checks if amount is null or equal to zero.
     */
    public static boolean isZeroOrNull(BigDecimal amount) {
        return amount == null || amount.compareTo(BigDecimal.ZERO) == 0;
    }

    /**
     * Null-safe addition with standard money scale.
     */
    public static BigDecimal safeAdd(BigDecimal a, BigDecimal b) {
        BigDecimal valA = a != null ? a : BigDecimal.ZERO;
        BigDecimal valB = b != null ? b : BigDecimal.ZERO;
        return scale(valA.add(valB));
    }

    /**
     * Null-safe subtraction with standard money scale.
     */
    public static BigDecimal safeSubtract(BigDecimal a, BigDecimal b) {
        BigDecimal valA = a != null ? a : BigDecimal.ZERO;
        BigDecimal valB = b != null ? b : BigDecimal.ZERO;
        return scale(valA.subtract(valB));
    }

    /**
     * Null-safe multiplication with standard money scale.
     */
    public static BigDecimal safeMultiply(BigDecimal a, BigDecimal b) {
        BigDecimal valA = a != null ? a : BigDecimal.ZERO;
        BigDecimal valB = b != null ? b : BigDecimal.ZERO;
        return scale(valA.multiply(valB));
    }

    /**
     * Safe division preventing ArithmeticException on zero divisor.
     * Returns BigDecimal.ZERO if denominator is zero or null.
     */
    public static BigDecimal safeDivide(BigDecimal numerator, BigDecimal denominator) {
        return safeDivide(numerator, denominator, CommonConstants.DEFAULT_MONEY_SCALE, CommonConstants.DEFAULT_ROUNDING_MODE);
    }

    /**
     * Safe division with specified scale and rounding mode.
     */
    public static BigDecimal safeDivide(BigDecimal numerator, BigDecimal denominator, int scale, RoundingMode roundingMode) {
        if (numerator == null || denominator == null || denominator.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO.setScale(scale, roundingMode);
        }
        return numerator.divide(denominator, scale, roundingMode);
    }

    /**
     * Calculates percentage: (part * 100) / total, uncapped.
     */
    public static BigDecimal percentage(BigDecimal part, BigDecimal total) {
        return percentage(part, total, false);
    }

    /**
     * Calculates percentage: (part * 100) / total.
     * Returns 0.00 if total is zero or null. Capped at 100.00 if capAt100 is true.
     */
    public static BigDecimal percentage(BigDecimal part, BigDecimal total, boolean capAt100) {
        if (part == null || total == null || total.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO.setScale(CommonConstants.DEFAULT_MONEY_SCALE, CommonConstants.DEFAULT_ROUNDING_MODE);
        }
        BigDecimal pct = part.multiply(BigDecimal.valueOf(100))
                .divide(total, CommonConstants.DEFAULT_MONEY_SCALE, CommonConstants.DEFAULT_ROUNDING_MODE);
        if (capAt100 && pct.compareTo(BigDecimal.valueOf(100)) > 0) {
            return BigDecimal.valueOf(100).setScale(CommonConstants.DEFAULT_MONEY_SCALE, CommonConstants.DEFAULT_ROUNDING_MODE);
        }
        return pct;
    }
}
