/// Response payload from POST /api/lifeUse/auth/register.
/// Matches com.lifeuse.auth.register.models.RegisterResponse.
class RegisterResponse {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final bool emailVerified;
  final bool phoneVerified;

  RegisterResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.emailVerified,
    required this.phoneVerified,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: (json['id'] as num?)?.toInt() ??
          (json['userId'] as num?)?.toInt() ??
          0,
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      emailVerified: json['emailVerified'] == true,
      phoneVerified: json['phoneVerified'] == true,
    );
  }
}
