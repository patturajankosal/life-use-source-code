/// Request payload for POST /api/lifeUse/auth/register.
/// Matches com.lifeuse.auth.register.models.RegisterRequest.
class RegisterRequest {
  final String username;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String password;
  final String confirmPassword;
  final String? verificationToken;

  RegisterRequest({
    required this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    this.verificationToken,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'username': username.trim(),
      'password': password,
      'confirmPassword': confirmPassword,
    };
    if (firstName != null && firstName!.isNotEmpty) {
      map['firstName'] = firstName!.trim();
    }
    if (lastName != null && lastName!.isNotEmpty) {
      map['lastName'] = lastName!.trim();
    }
    if (email != null && email!.isNotEmpty) {
      map['email'] = email!.trim().toLowerCase();
    }
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      map['phoneNumber'] = phoneNumber!.trim();
    }
    if (verificationToken != null && verificationToken!.isNotEmpty) {
      map['verificationToken'] = verificationToken!.trim();
    }
    return map;
  }
}
