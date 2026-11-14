/// Request payload for POST /api/lifeUse/auth/login.
/// Matches com.lifeuse.auth.login.models.LoginRequest.
class LoginRequest {
  final String identifier; // Username, Email, or Phone number
  final String password;

  LoginRequest({
    required this.identifier,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier.trim(),
      'password': password,
    };
  }
}
