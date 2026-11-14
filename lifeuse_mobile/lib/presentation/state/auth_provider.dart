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

  /// Perform login
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

  /// Perform registration
  Future<RegisterResponse?> register(RegisterRequest request) async {
    _setLoading(true);
    _clearErrors();

    try {
      final response = await _authService.register(request);
      _successMessage =
          'Registration successful! Please sign in with your credentials.';
      notifyListeners();
      return response;
    } on ApiException catch (e) {
      _errorMessage = _mapErrorCodeToMessage(e.errorCode, e.message);
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'Registration failed. Please check your network and try again.';
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Request password reset
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _clearErrors();
    try {
      await _authService.forgotPassword(email);
      _successMessage = 'Password reset instructions sent to $email';
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = _mapErrorCodeToMessage(e.errorCode, e.message);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Failed to request password reset. Please try again.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

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
      case 'VALIDATION_FAILED':
        return defaultMsg.isNotEmpty ? defaultMsg : 'Please check the form inputs.';
      default:
        return defaultMsg;
    }
  }
}
