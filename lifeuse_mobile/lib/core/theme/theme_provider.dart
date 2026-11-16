import 'package:flutter/material.dart';

/// Central state provider for automatic system theme detection.
/// Follows the user's Android/iOS system appearance settings as the single source of truth.
/// File: lib/core/theme/theme_provider.dart
class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  ThemeMode get themeMode => ThemeMode.system;

  bool _isSystemDark =
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  bool get isDarkMode => _isSystemDark;
  bool get isDark => _isSystemDark;

  void toggleTheme() {
    _isSystemDark = !_isSystemDark;
    notifyListeners();
  }

  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
    _syncWithSystem();
  }

  void _syncWithSystem() {
    final isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    if (_isSystemDark != isDark) {
      _isSystemDark = isDark;
      notifyListeners();
    }
  }

  @override
  void didChangePlatformBrightness() {
    _syncWithSystem();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
