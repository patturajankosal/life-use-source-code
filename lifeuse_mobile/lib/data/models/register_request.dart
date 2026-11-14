/// Request payload for POST /api/lifeUse/auth/register.
/// Matches com.lifeuse.auth.register.models.RegisterRequest.
class RegisterRequest {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.username,
    this.firstName = '',
    this.lastName = '',
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username.trim(),
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.trim().toLowerCase(),
      'phoneNumber': phoneNumber.trim(),
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
