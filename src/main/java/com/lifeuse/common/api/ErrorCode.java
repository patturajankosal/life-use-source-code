package com.lifeuse.common.api;

import com.lifeuse.common.ApiResponse;

/**
 * Standard enterprise error code reference for cross-module consumption.
 * Inherits all constants from {@link ApiResponse.ErrorCode}.
 */
public final class ErrorCode {

    private ErrorCode() {}

    // Auth & Access
    public static final String INVALID_CREDENTIALS            = ApiResponse.ErrorCode.INVALID_CREDENTIALS;
    public static final String ACCOUNT_DISABLED               = ApiResponse.ErrorCode.ACCOUNT_DISABLED;
    public static final String ACCOUNT_LOCKED                 = ApiResponse.ErrorCode.ACCOUNT_LOCKED;
    public static final String AUTHENTICATION_REQUIRED        = ApiResponse.ErrorCode.AUTHENTICATION_REQUIRED;
    public static final String ACCESS_DENIED                  = ApiResponse.ErrorCode.ACCESS_DENIED;
    public static final String TOKEN_EXPIRED                  = ApiResponse.ErrorCode.TOKEN_EXPIRED;

    // Validation & Business
    public static final String VALIDATION_FAILED              = ApiResponse.ErrorCode.VALIDATION_FAILED;
    public static final String VALIDATION_ERROR               = ApiResponse.ErrorCode.VALIDATION_ERROR;
    public static final String RESOURCE_NOT_FOUND             = ApiResponse.ErrorCode.RESOURCE_NOT_FOUND;
    public static final String DUPLICATE_RESOURCE             = ApiResponse.ErrorCode.DUPLICATE_RESOURCE;
    public static final String BAD_REQUEST                    = ApiResponse.ErrorCode.BAD_REQUEST;
    public static final String BUSINESS_RULE_VIOLATION        = ApiResponse.ErrorCode.BUSINESS_RULE_VIOLATION;

    // Database & System
    public static final String DATABASE_ERROR                 = ApiResponse.ErrorCode.DATABASE_ERROR;
    public static final String DATABASE_CONSTRAINT_VIOLATION  = ApiResponse.ErrorCode.DATABASE_CONSTRAINT_VIOLATION;
    public static final String INTERNAL_SERVER_ERROR          = ApiResponse.ErrorCode.INTERNAL_SERVER_ERROR;
    public static final String SERVICE_UNAVAILABLE            = ApiResponse.ErrorCode.SERVICE_UNAVAILABLE;

    // Money Manager
    public static final String PROFILE_NOT_FOUND              = ApiResponse.ErrorCode.PROFILE_NOT_FOUND;
    public static final String INVALID_AMOUNT                 = ApiResponse.ErrorCode.INVALID_AMOUNT;
    public static final String INSUFFICIENT_FUNDS             = ApiResponse.ErrorCode.INSUFFICIENT_FUNDS;
    public static final String CATEGORY_NOT_FOUND             = ApiResponse.ErrorCode.CATEGORY_NOT_FOUND;
    public static final String BUDGET_PLAN_NOT_FOUND          = ApiResponse.ErrorCode.BUDGET_PLAN_NOT_FOUND;
    public static final String BUDGET_OVERSPENT               = ApiResponse.ErrorCode.BUDGET_OVERSPENT;
    public static final String PLANNED_EXPENSE_NOT_FOUND      = ApiResponse.ErrorCode.PLANNED_EXPENSE_NOT_FOUND;
    public static final String SCHEDULE_NOT_FOUND             = ApiResponse.ErrorCode.SCHEDULE_NOT_FOUND;
    public static final String INVALID_DATE_RANGE             = ApiResponse.ErrorCode.INVALID_DATE_RANGE;
    public static final String DUPLICATE_TRANSACTION          = ApiResponse.ErrorCode.DUPLICATE_TRANSACTION;
    public static final String COMMITMENT_NOT_FOUND           = ApiResponse.ErrorCode.COMMITMENT_NOT_FOUND;
}
