import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/api_config.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';
import '../models/user_model.dart';
import 'api_client.dart';

/// Authentication service managing API calls and local token/session persistence.
class AuthService {
  final ApiClient _apiClient;

  static const String _keyAccessToken = 'lifeuse_access_token';
  static const String _keyRefreshToken = 'lifeuse_refresh_token';
  static const String _keyUser = 'lifeuse_user_profile';

  AuthService(this._apiClient);

  /// Authenticate user via POST /api/lifeUse/auth/login
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiClient.post<LoginResponse>(
      url: ApiConfig.login,
      body: request.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Login failed: No authentication data returned',
        statusCode: 500,
      );
    }

    final loginData = response.data!;

    // Persist session locally
    await _saveSession(
      accessToken: loginData.accessToken,
      refreshToken: loginData.refreshToken,
      user: loginData.user,
    );

    _apiClient.setAccessToken(loginData.accessToken);
    return loginData;
  }

  /// Register new user via POST /api/lifeUse/auth/register
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _apiClient.post<RegisterResponse>(
      url: ApiConfig.register,
      body: request.toJson(),
      fromJson: (json) => RegisterResponse.fromJson(json as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Registration failed: No user data returned',
        statusCode: 500,
      );
    }

    return response.data!;
  }

  /// Request password reset via POST /api/lifeUse/auth/password/forgot
  Future<void> forgotPassword(String email) async {
    await _apiClient.post(
      url: ApiConfig.forgotPassword,
      body: {'email': email.trim().toLowerCase()},
    );
  }

  /// Fetch currently authenticated user via GET /api/lifeUse/user/me
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get<UserModel>(
      url: ApiConfig.me,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw ApiException(
        message: 'Failed to load profile data',
        statusCode: 404,
      );
    }

    final user = response.data!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
    return user;
  }

  /// Restore persisted session from SharedPreferences
  Future<UserModel?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyAccessToken);
    final userJson = prefs.getString(_keyUser);

    if (token != null && token.isNotEmpty && userJson != null) {
      _apiClient.setAccessToken(token);
      try {
        final decoded = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(decoded);
      } catch (_) {
        await logout();
        return null;
      }
    }
    return null;
  }

  /// Save authentication tokens and user model
  Future<void> _saveSession({
    required String accessToken,
    required String refreshToken,
    required UserModel user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  /// Clear session and logout (including server-side refresh token revocation)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString(_keyRefreshToken);

    // Call server-side revoke token if refresh token exists
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await _apiClient.post(
          url: ApiConfig.logout,
          body: {'refreshToken': refreshToken},
        );
      } catch (_) {
        // Continue clearing local state even if network fails
      }
    }

    _apiClient.setAccessToken(null);
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUser);
  }
}
