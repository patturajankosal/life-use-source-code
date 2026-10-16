package com.lifeuse.common;

import com.lifeuse.AppRoutes;

public final class SecurityConstants {

    private SecurityConstants() {
        // Prevent instantiation
    }

    public static final String AUTH_HEADER = "Authorization";
    public static final String BEARER_PREFIX = "Bearer ";
    public static final String TOKEN_TYPE = "Bearer";

    // Public API route patterns delegated to centralized AppRoutes
    public static final String[] PUBLIC_URLS = AppRoutes.PUBLIC_ROUTES;
}
