/// Enterprise Centralized Constants for LifeUse.
/// File: lib/core/config/app_constants.dart
///
/// Mirrors Spring Boot AppRoutes and SecurityConstants.
class AppConstants {
  AppConstants._();

  // Application Info
  static const String appName = 'LifeUse';
  static const String appVersion = '1.0.0';
  static const String copyright = '© 2026 LIFEUSE. All rights reserved.';

  // Storage Keys (SharedPreferences)
  static const String keyAccessToken = 'lifeuse_access_token';
  static const String keyRefreshToken = 'lifeuse_refresh_token';
  static const String keyUserData = 'lifeuse_user_data';
  static const String keyThemeMode = 'lifeuse_theme_mode';

  // Navigation Route Names
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routeDashboard = '/dashboard';
}
