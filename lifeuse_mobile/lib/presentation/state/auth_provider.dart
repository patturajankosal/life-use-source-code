import 'package:flutter/foundation.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/register_response.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_client.dart';
import '../../data/services/auth_service.dart';

/// State management provider for authentication lifecycle.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  AuthProvider(this._authService);

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Check and restore existing login session
  Future<void> checkSession() async {
    _setLoading(true);
    try {
      _currentUser = await _authService.restoreSession();
    } catch (_) {
      _currentUser = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Perform login with username, email, or mobile number
  Future<bool> login(String identifier, String password) async {
    _setLoading(true);
    _clearErrors();

    try {
      final loginData = await _authService.login(
        LoginRequest(identifier: identifier, password: password),
      );
      _currentUser = loginData.user;
      _successMessage = 'Welcome back, ${_currentUser!.fullName}';
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = _mapErrorCodeToMessage(e.errorCode, e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Send registration OTP to identifier (email or mobile number)
  Future<bool> sendRegistrationOtp({
    required String identifier,
    required String type,
  }) async {
    _setLoading(true);
    _clearErrors();

    try {
      await _authService.sendRegistrationOtp(
        identifier: identifier,
        type: type,
      );
      _successMessage = 'Verification code sent to $identifier';
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = _mapErrorCodeToMessage(e.errorCode, e.message);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage =
          'Failed to send verification code. Please check your network.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Verify registration OTP and obtain a verification token
  Future<String?> verifyRegistrationOtp({
    required String identifier,
    required String type,
    required String otpCode,
  }) async {
    _setLoading(true);
    _clearErrors();

    try {
      String? token;
      if (type.toUpperCase() == 'EMAIL') {
        token = await _authService.verifyEmailOtp(
          email: identifier,
          otpCode: otpCode,
        );
      } else {
        token = await _authService.verifyPhoneOtp(
          phoneNumber: identifier,
          otpCode: otpCode,
        );
      }

      if (token != null && token.isNotEmpty) {
        _successMessage = 'Verification successful!';
        notifyListeners();
        return token;
      } else {
        _errorMessage = 'Invalid or expired OTP code.';
        notifyListeners();
        return null;
      }
    } on ApiException catch (e) {
      _errorMessage = _mapErrorCodeToMessage(e.errorCode, e.message);
      notifyListeners();
      return null;
    } catch (_) {
      _errorMessage = 'Failed to verify OTP code. Please try again.';
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Resend verification OTP
  Future<bool> resendOtp({
    required String identifier,
    required String type,
  }) async {
    _setLoading(true);
    _clearErrors();

    try {
      await _authService.resendOtp(identifier: identifier, type: type);
      _successMessage = 'New code sent to $identifier';
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = _mapErrorCodeToMessage(e.errorCode, e.message);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Failed to resend code. Please wait a moment.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Complete multi-step registration and auto-log in to dashboard
  Future<bool> completeRegistration({
    required String username,
    required String password,
    required String confirmPassword,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? verificationToken,
  }) async {
    _setLoading(true);
    _clearErrors();

    try {
      final request = RegisterRequest(
        username: username.trim(),
        password: password,
        confirmPassword: confirmPassword,
        email: email?.trim(),
        phoneNumber: phoneNumber?.trim(),
        firstName: firstName?.trim(),
        lastName: lastName?.trim(),
        verificationToken: verificationToken,
      );

      final response = await _authService.register(request);
      if (response.hasSession) {
        _currentUser = response.toUserModel();
      }
      _successMessage = 'Welcome to LifeUse, @${response.username}!';
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = _mapErrorCodeToMessage(e.errorCode, e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Perform direct registration (backward compatibility)
  Future<RegisterResponse?> register(RegisterRequest request) async {
    _setLoading(true);
    _clearErrors();

    try {
      final response = await _authService.register(request);
      if (response.hasSession) {
        _currentUser = response.toUserModel();
      }
      _successMessage = 'Welcome to LifeUse, @${response.username}!';
      notifyListeners();
      return response;
    } on ApiException catch (e) {
      _errorMessage = _mapErrorCodeToMessage(e.errorCode, e.message);
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage =
          'Registration failed. Please check your network and try again.';
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Request password reset OTP
  Future<bool> sendForgotPasswordOtp(String identifier) async {
    _setLoading(true);
    _clearErrors();
    try {
      await _authService.forgotPassword(identifier);
      _successMessage = 'Verification code sent to $identifier';
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = _mapErrorCodeToMessage(e.errorCode, e.message);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Failed to send reset code. Please try again.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Verify password reset OTP
  Future<String?> verifyForgotPasswordOtp({
    required String identifier,
    required String otpCode,
  }) async {
    _setLoading(true);
    _clearErrors();
    try {
      final token = await _authService.verifyForgotPasswordOtp(
        identifier: identifier,
        otpCode: otpCode,
      );
      _successMessage = 'Code verified!';
      notifyListeners();
      return token;
    } on ApiException catch (e) {
      _errorMessage = _mapErrorCodeToMessage(e.errorCode, e.message);
      notifyListeners();
      return null;
    } catch (_) {
      _errorMessage = 'Invalid or expired reset code.';
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password using reset token
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _clearErrors();
    try {
      await _authService.resetPassword(
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _successMessage = 'Password reset successfully! Please sign in.';
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = _mapErrorCodeToMessage(e.errorCode, e.message);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Failed to reset password. Please try again.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh currently authenticated user profile from GET /api/lifeUse/user/me
  Future<void> refreshProfile() async {
    if (_currentUser == null) return;
    try {
      final user = await _authService.getCurrentUser();
      _currentUser = user;
      notifyListeners();
    } catch (_) {
      // Keep existing session user if network request fails
    }
  }

  /// Legacy forgot password (calls sendForgotPasswordOtp)
  Future<bool> forgotPassword(String email) => sendForgotPasswordOtp(email);

  /// Logout
  Future<void> logout() async {
    _setLoading(true);
    await _authService.logout();
    _currentUser = null;
    _errorMessage = null;
    _successMessage = 'You have been logged out';
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearErrors() {
    _errorMessage = null;
    _successMessage = null;
  }

  /// Translate Spring Boot error codes into friendly user messages
  String _mapErrorCodeToMessage(String? errorCode, String defaultMsg) {
    if (errorCode == null) return defaultMsg;
    switch (errorCode) {
      case 'INVALID_CREDENTIALS':
        return 'Invalid identifier or password. Please try again.';
      case 'ACCOUNT_DISABLED':
        return 'Your account is currently disabled. Please contact support.';
      case 'EMAIL_ALREADY_EXISTS':
        return 'An account with this email address already exists.';
      case 'USERNAME_ALREADY_EXISTS':
        return 'This username is already taken. Please choose another.';
      case 'PHONE_ALREADY_EXISTS':
        return 'This phone number is already registered with an account.';
      case 'INVALID_OTP':
        return 'Invalid OTP code. Please check and try again.';
      case 'OTP_EXPIRED':
        return 'This verification code has expired. Please request a new code.';
      case 'OTP_ATTEMPTS_EXCEEDED':
        return 'Too many invalid attempts. Please request a new code.';
      case 'OTP_RESEND_COOLDOWN':
        return 'Please wait before requesting another code.';
      case 'CONTACT_NOT_VERIFIED':
        return 'Contact verification is required before proceeding.';
      case 'PASSWORD_MISMATCH':
        return 'Passwords do not match.';
      case 'VALIDATION_FAILED':
        return defaultMsg.isNotEmpty
            ? defaultMsg
            : 'Please check the form inputs.';
      default:
        return defaultMsg;
    }
  }
}
