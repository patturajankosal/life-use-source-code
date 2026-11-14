/// Client-side validation logic matching Spring Boot backend validation rules.
class Validators {
  Validators._();

  // Regex patterns directly matching backend:
  // - Username pattern: ^[a-zA-Z0-9._-]+$
  static final RegExp _usernameRegex = RegExp(r'^[a-zA-Z0-9._-]+$');

  // - Email standard regex
  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

  // - E.164 phone pattern: ^\+?[1-9]\d{1,14}$
  static final RegExp _phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');

  // - Password pattern from PasswordValidator.java:
  //   At least 8 chars, 1 digit, 1 lower, 1 upper, 1 special char (@#$%^&+=!._-)
  static final RegExp _passwordDigitRegex = RegExp(r'[0-9]');
  static final RegExp _passwordLowerRegex = RegExp(r'[a-z]');
  static final RegExp _passwordUpperRegex = RegExp(r'[A-Z]');
  static final RegExp _passwordSpecialRegex = RegExp(r'[@#$%^&+=!._-]');

  static String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your username, email, or phone number';
    }
    if (value.trim().length < 3) {
      return 'Identifier must be at least 3 characters';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    final clean = value.trim();
    if (clean.length < 3 || clean.length > 30) {
      return 'Username must be between 3 and 30 characters';
    }
    if (!_usernameRegex.hasMatch(clean)) {
      return 'Can only contain letters, numbers, dots, underscores, and hyphens';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final clean = value.trim();
    if (!_emailRegex.hasMatch(clean)) {
      return 'Please provide a valid email address';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final clean = value.trim();
    if (!_phoneRegex.hasMatch(clean)) {
      return 'Use international format (e.g. +1234567890)';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!_passwordUpperRegex.hasMatch(value)) {
      return 'Must include at least one uppercase letter (A-Z)';
    }
    if (!_passwordLowerRegex.hasMatch(value)) {
      return 'Must include at least one lowercase letter (a-z)';
    }
    if (!_passwordDigitRegex.hasMatch(value)) {
      return 'Must include at least one number (0-9)';
    }
    if (!_passwordSpecialRegex.hasMatch(value)) {
      return 'Must include at least one special character (@#\$%^&+=!._-)';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
