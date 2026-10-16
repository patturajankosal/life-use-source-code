package com.lifeuse;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("AppRoutes Centralized Architecture & HTTP Method Identification Tests")
class AppRoutesTest {

    @Test
    @DisplayName("Should verify that all Auth route constants have explicit HTTP method prefixes")
    void shouldVerifyAuthRouteMethodPrefixes() {
        assertTrue(AppRoutes.Auth.POST_LOGIN.startsWith("/api/lifeUse/auth/"));
        assertTrue(AppRoutes.Auth.POST_REGISTER.startsWith("/api/lifeUse/auth/"));
        assertTrue(AppRoutes.Auth.POST_VERIFY_EMAIL.startsWith("/api/lifeUse/auth/"));
        assertTrue(AppRoutes.Auth.POST_VERIFY_PHONE.startsWith("/api/lifeUse/auth/"));
        assertTrue(AppRoutes.Auth.POST_RESEND_OTP.startsWith("/api/lifeUse/auth/"));
        assertTrue(AppRoutes.Auth.POST_FORGOT_PASSWORD.startsWith("/api/lifeUse/auth/"));
        assertTrue(AppRoutes.Auth.POST_RESET_PASSWORD.startsWith("/api/lifeUse/auth/"));
        assertTrue(AppRoutes.Auth.POST_CHANGE_PASSWORD.startsWith("/api/lifeUse/auth/"));
        assertTrue(AppRoutes.Auth.POST_REFRESH_TOKEN.startsWith("/api/lifeUse/auth/"));
        assertTrue(AppRoutes.Auth.POST_LOGOUT.startsWith("/api/lifeUse/auth/"));

        // Verify backwards-compatible aliases match
        assertEquals(AppRoutes.Auth.POST_LOGIN, AppRoutes.Auth.LOGIN);
        assertEquals(AppRoutes.Auth.POST_REGISTER, AppRoutes.Auth.REGISTER);
        assertEquals(AppRoutes.Auth.POST_REFRESH_TOKEN, AppRoutes.Auth.REFRESH_TOKEN);
        assertEquals(AppRoutes.Auth.POST_LOGOUT, AppRoutes.Auth.LOGOUT);
    }

    @Test
    @DisplayName("Should verify that User route constants have explicit HTTP method prefixes")
    void shouldVerifyUserRouteMethodPrefixes() {
        assertEquals("/api/lifeUse/user/me", AppRoutes.User.GET_ME);
        assertEquals("/api/lifeUse/user/profile", AppRoutes.User.PUT_UPDATE_PROFILE);
        assertEquals("/api/lifeUse/user/delete", AppRoutes.User.DELETE_ACCOUNT);

        // Verify aliases
        assertEquals(AppRoutes.User.GET_ME, AppRoutes.User.ME);
        assertEquals(AppRoutes.User.PUT_UPDATE_PROFILE, AppRoutes.User.UPDATE_PROFILE);
    }

    @Test
    @DisplayName("Should verify that Notification and Feed routes have HTTP method prefixes")
    void shouldVerifyFutureModuleRouteMethodPrefixes() {
        assertEquals("/api/lifeUse/notification/list", AppRoutes.Notification.GET_LIST);
        assertEquals("/api/lifeUse/notification/read", AppRoutes.Notification.PUT_MARK_READ);
        assertEquals("/api/lifeUse/notification/delete", AppRoutes.Notification.DELETE_NOTIFICATION);

        assertEquals("/api/lifeUse/feed/list", AppRoutes.Feed.GET_FEED_LIST);
        assertEquals("/api/lifeUse/feed/post", AppRoutes.Feed.POST_CREATE_POST);
        assertEquals("/api/lifeUse/feed/post/delete", AppRoutes.Feed.DELETE_POST);
    }

    @Test
    @DisplayName("Should verify public routes array contains expected unauthenticated endpoints")
    void shouldVerifyPublicRoutesArray() {
        assertNotNull(AppRoutes.PUBLIC_ROUTES);
        assertTrue(AppRoutes.PUBLIC_ROUTES.length >= 8);

        List<String> publicList = List.of(AppRoutes.PUBLIC_ROUTES);
        assertTrue(publicList.contains(AppRoutes.Auth.POST_LOGIN));
        assertTrue(publicList.contains(AppRoutes.Auth.POST_REGISTER));
        assertTrue(publicList.contains(AppRoutes.Auth.POST_REFRESH_TOKEN));
    }

    @Test
    @DisplayName("Should verify route metadata registry returns valid mapped routes")
    void shouldVerifyRouteMetadataRegistry() {
        List<AppRoutes.RouteMetadata> routes = AppRoutes.getAllDefinedRoutes();
        assertNotNull(routes);
        assertFalse(routes.isEmpty());

        for (AppRoutes.RouteMetadata route : routes) {
            assertNotNull(route.httpMethod());
            assertTrue(List.of("GET", "POST", "PUT", "DELETE", "PATCH").contains(route.httpMethod()));
            assertTrue(route.path().startsWith("/api/lifeUse/"));
            assertNotNull(route.targetController());
            assertNotNull(route.targetMethod());
        }
    }
}
