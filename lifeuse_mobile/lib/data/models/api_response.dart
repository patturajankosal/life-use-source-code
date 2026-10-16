/// Maps the standard Spring Boot ApiResponse<T> JSON envelope:
/// {
///   "success": true | false,
///   "errorCode": "INVALID_CREDENTIALS",
///   "message": "...",
///   "data": { ... },
///   "timestamp": 1791800077.4560094 | "2026-10-12T10:15:30Z"
/// }
class ApiResponse<T> {
  final bool success;
  final String? errorCode;
  final String message;
  final T? data;
  final String? timestamp;

  ApiResponse({
    required this.success,
    this.errorCode,
    required this.message,
    this.data,
    this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      errorCode: json['errorCode']?.toString(),
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      timestamp: json['timestamp']?.toString(),
    );
  }
}
