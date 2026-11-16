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

  /// Request initial OTP for pre-registration via POST /api/lifeUse/auth/verify/send
  Future<Map<String, dynamic>> sendRegistrationOtp({
    required String identifier,
    required String type,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      url: ApiConfig.sendOtp,
      body: {
        'identifier': identifier.trim(),
        'type': type.toUpperCase(),
      },
      fromJson: (json) => json is Map<String, dynamic> ? json : {},
    );
    return response.data ?? {};
  }

  /// Verify 6-digit email OTP via POST /api/lifeUse/auth/verify/email
  Future<String?> verifyEmailOtp({
    required String email,
    required String otpCode,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      url: ApiConfig.verifyEmail,
      body: {
        'email': email.trim().toLowerCase(),
        'otpCode': otpCode.trim(),
      },
      fromJson: (json) => json is Map<String, dynamic> ? json : {},
    );
    return response.data?['verificationToken']?.toString();
  }

  /// Verify 6-digit phone OTP via POST /api/lifeUse/auth/verify/phone
  Future<String?> verifyPhoneOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      url: ApiConfig.verifyPhone,
      body: {
        'phoneNumber': phoneNumber.trim(),
        'otpCode': otpCode.trim(),
      },
      fromJson: (json) => json is Map<String, dynamic> ? json : {},
    );
    return response.data?['verificationToken']?.toString();
  }

  /// Resend OTP code via POST /api/lifeUse/auth/verify/resend
  Future<void> resendOtp({
    required String identifier,
    required String type,
  }) async {
    await _apiClient.post(
      url: ApiConfig.resendOtp,
      body: {
        'identifier': identifier.trim(),
        'type': type.toUpperCase(),
      },
    );
  }

  /// Complete registration and persist session if tokens returned
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _apiClient.post<RegisterResponse>(
      url: ApiConfig.register,
      body: request.toJson(),
      fromJson: (json) =>
          RegisterResponse.fromJson(json as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Registration failed: No user data returned',
        statusCode: 500,
      );
    }

    final regData = response.data!;

    // If backend issued session tokens upon registration, persist session immediately
    if (regData.hasSession) {
      final userModel = regData.toUserModel();
      await _saveSession(
        accessToken: regData.accessToken!,
        refreshToken: regData.refreshToken!,
        user: userModel,
      );
      _apiClient.setAccessToken(regData.accessToken!);
    }

    return regData;
  }

  /// Request password reset via POST /api/lifeUse/auth/password/forgot
  Future<void> forgotPassword(String identifier) async {
    final trimmed = identifier.trim();
    await _apiClient.post(
      url: ApiConfig.forgotPassword,
      body: {
        'identifier': trimmed,
        'email': trimmed.contains('@') ? trimmed.toLowerCase() : trimmed,
      },
    );
  }

  /// Verify password reset OTP via POST /api/lifeUse/auth/password/verify
  Future<String> verifyForgotPasswordOtp({
    required String identifier,
    required String otpCode,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      url: ApiConfig.verifyPasswordOtp,
      body: {
        'email': identifier.trim(),
        'otpCode': otpCode.trim(),
      },
      fromJson: (json) => json is Map<String, dynamic> ? json : {},
    );

    final token = response.data?['token']?.toString();
    if (token == null || token.isEmpty) {
      throw ApiException(
        message: 'Password reset token not received',
        statusCode: 500,
      );
    }
    return token;
  }

  /// Reset password via POST /api/lifeUse/auth/password/reset
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _apiClient.post(
      url: ApiConfig.resetPassword,
      body: {
        'token': token.trim(),
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
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
