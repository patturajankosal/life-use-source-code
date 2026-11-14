/// Enterprise Application Exception hierarchy for LifeUse.
/// File: lib/core/errors/app_exception.dart
///
/// Mirrors Spring Boot backend common exceptions:
/// - BusinessException
/// - ResourceNotFoundException
/// - DuplicateResourceException
/// - UnauthorizedException
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AppException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'AppException: $message (Status: $statusCode)';
}

/// Network connectivity / communication failure
class NetworkException extends AppException {
  const NetworkException(super.message, {super.statusCode, super.details});
}

/// Business rule violation (e.g. invalid credentials, unverified account)
class BusinessException extends AppException {
  const BusinessException(super.message, {super.statusCode, super.details});
}

/// 401 Unauthorized / Token Expired
class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.statusCode, super.details});
}

/// 404 Resource Not Found
class ResourceNotFoundException extends AppException {
  const ResourceNotFoundException(super.message, {super.statusCode, super.details});
}
