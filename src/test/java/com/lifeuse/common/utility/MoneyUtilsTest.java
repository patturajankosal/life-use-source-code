package com.lifeuse.common.utility;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("MoneyUtils Unit Tests")
class MoneyUtilsTest {

    @Test
    @DisplayName("Should correctly scale amounts to 2 decimal places with HALF_UP rounding")
    void testScale() {
        assertEquals(new BigDecimal("0.00"), MoneyUtils.scale(null));
        assertEquals(new BigDecimal("10.56"), MoneyUtils.scale(new BigDecimal("10.555")));
        assertEquals(new BigDecimal("10.55"), MoneyUtils.scale(new BigDecimal("10.554")));
        assertEquals(new BigDecimal("10.00"), MoneyUtils.scale(new BigDecimal("10")));
    }

    @Test
    @DisplayName("Should format monetary amounts to standard 2-decimal string")
    void testFormat() {
        assertEquals("0.00", MoneyUtils.format(null));
        assertEquals("1234.50", MoneyUtils.format(new BigDecimal("1234.5")));
        assertEquals("0.00", MoneyUtils.format(BigDecimal.ZERO));
    }

    @Test
    @DisplayName("Should compare equality using compareTo ignoring scale differences")
    void testIsEqual() {
        assertTrue(MoneyUtils.isEqual(new BigDecimal("100.00"), new BigDecimal("100.0000")));
        assertTrue(MoneyUtils.isEqual(null, null));
        assertFalse(MoneyUtils.isEqual(new BigDecimal("100.00"), null));
        assertFalse(MoneyUtils.isEqual(null, new BigDecimal("100.00")));
        assertFalse(MoneyUtils.isEqual(new BigDecimal("100.00"), new BigDecimal("100.01")));
    }

    @Test
    @DisplayName("Should correctly evaluate positive, non-negative, and zero or null")
    void testNumericPredicates() {
        assertTrue(MoneyUtils.isPositive(new BigDecimal("0.01")));
        assertFalse(MoneyUtils.isPositive(BigDecimal.ZERO));
        assertFalse(MoneyUtils.isPositive(new BigDecimal("-5.00")));
        assertFalse(MoneyUtils.isPositive(null));

        assertTrue(MoneyUtils.isNonNegative(BigDecimal.ZERO));
        assertTrue(MoneyUtils.isNonNegative(new BigDecimal("10.00")));
        assertFalse(MoneyUtils.isNonNegative(new BigDecimal("-0.01")));
        assertFalse(MoneyUtils.isNonNegative(null));

        assertTrue(MoneyUtils.isZeroOrNull(null));
        assertTrue(MoneyUtils.isZeroOrNull(BigDecimal.ZERO));
        assertTrue(MoneyUtils.isZeroOrNull(new BigDecimal("0.0000")));
        assertFalse(MoneyUtils.isZeroOrNull(new BigDecimal("1.00")));
    }

    @Test
    @DisplayName("Should perform safe arithmetic handling nulls seamlessly")
    void testSafeArithmetic() {
        assertEquals(new BigDecimal("30.00"), MoneyUtils.safeAdd(new BigDecimal("10.00"), new BigDecimal("20.00")));
        assertEquals(new BigDecimal("10.00"), MoneyUtils.safeAdd(new BigDecimal("10.00"), null));
        assertEquals(new BigDecimal("20.00"), MoneyUtils.safeAdd(null, new BigDecimal("20.00")));

        assertEquals(new BigDecimal("15.00"), MoneyUtils.safeSubtract(new BigDecimal("25.00"), new BigDecimal("10.00")));
        assertEquals(new BigDecimal("25.00"), MoneyUtils.safeSubtract(new BigDecimal("25.00"), null));
        assertEquals(new BigDecimal("-10.00"), MoneyUtils.safeSubtract(null, new BigDecimal("10.00")));

        assertEquals(new BigDecimal("50.00"), MoneyUtils.safeMultiply(new BigDecimal("10.00"), new BigDecimal("5")));
        assertEquals(new BigDecimal("0.00"), MoneyUtils.safeMultiply(new BigDecimal("10.00"), null));
    }

    @Test
    @DisplayName("Should divide safely without throwing ArithmeticException on zero or null denominator")
    void testSafeDivide() {
        assertEquals(new BigDecimal("5.00"), MoneyUtils.safeDivide(new BigDecimal("10.00"), new BigDecimal("2.00")));
        assertEquals(new BigDecimal("0.00"), MoneyUtils.safeDivide(new BigDecimal("10.00"), BigDecimal.ZERO));
        assertEquals(new BigDecimal("0.00"), MoneyUtils.safeDivide(new BigDecimal("10.00"), null));
        assertEquals(new BigDecimal("0.00"), MoneyUtils.safeDivide(null, new BigDecimal("2.00")));
    }

    @Test
    @DisplayName("Should calculate percentage accurately with zero division protection")
    void testPercentage() {
        assertEquals(new BigDecimal("50.00"), MoneyUtils.percentage(new BigDecimal("50.00"), new BigDecimal("100.00")));
        assertEquals(new BigDecimal("33.33"), MoneyUtils.percentage(new BigDecimal("1.00"), new BigDecimal("3.00")));
        assertEquals(new BigDecimal("0.00"), MoneyUtils.percentage(new BigDecimal("50.00"), BigDecimal.ZERO));
        assertEquals(new BigDecimal("0.00"), MoneyUtils.percentage(null, new BigDecimal("100.00")));
    }
}
