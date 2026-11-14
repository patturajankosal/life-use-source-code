import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Central state provider for managing Dark Mode & Light Mode.
/// File: lib/core/theme/theme_provider.dart
class ThemeProvider extends ChangeNotifier {
  static const String _keyThemeMode = 'lifeuse_theme_mode';

  ThemeMode _themeMode = ThemeMode.dark; // Default to dark aesthetic

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isDark => isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_keyThemeMode);
      if (saved != null) {
        if (saved == 'light') {
          _themeMode = ThemeMode.light;
        } else if (saved == 'dark') {
          _themeMode = ThemeMode.dark;
        } else {
          _themeMode = ThemeMode.system;
        }
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _keyThemeMode,
        _themeMode == ThemeMode.dark ? 'dark' : 'light',
      );
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyThemeMode, mode.name);
    } catch (_) {}
  }
}
