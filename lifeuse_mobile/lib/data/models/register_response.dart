import 'user_model.dart';

/// Response payload from POST /api/lifeUse/auth/register.
/// Matches com.lifeuse.auth.register.models.RegisterResponse.
class RegisterResponse {
  final int id;
  final String username;
  final String? email;
  final String? phoneNumber;
  final bool emailVerified;
  final bool phoneVerified;
  final String? accessToken;
  final String? refreshToken;
  final String tokenType;
  final int? expiresIn;

  RegisterResponse({
    required this.id,
    required this.username,
    this.email,
    this.phoneNumber,
    required this.emailVerified,
    required this.phoneVerified,
    this.accessToken,
    this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresIn,
  });

  bool get hasSession =>
      accessToken != null &&
      accessToken!.isNotEmpty &&
      refreshToken != null &&
      refreshToken!.isNotEmpty;

  UserModel toUserModel() {
    return UserModel(
      id: id,
      username: username,
      firstName: '',
      lastName: '',
      email: email ?? '',
      phoneNumber: phoneNumber ?? '',
      role: 'ROLE_USER',
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
    );
  }

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: (json['id'] as num?)?.toInt() ??
          (json['userId'] as num?)?.toInt() ??
          0,
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      emailVerified: json['emailVerified'] == true,
      phoneVerified: json['phoneVerified'] == true,
      accessToken: json['accessToken']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
      tokenType: json['tokenType']?.toString() ?? 'Bearer',
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
    );
  }
}
