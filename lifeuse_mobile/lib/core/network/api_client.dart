import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../../data/models/api_response.dart';

/// Custom exception containing backend error message and code.
class ApiException implements Exception {
  final String message;
  final String? errorCode;
  final int statusCode;

  ApiException({
    required this.message,
    this.errorCode,
    required this.statusCode,
  });

  @override
  String toString() => message;
}

/// Robust HTTP client with standard headers, timeout handling, and ApiResponse parsing.
/// File: lib/core/network/api_client.dart
class ApiClient {
  final http.Client _client = http.Client();
  String? _accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  /// Helper to send POST with automatic host failover (USB <-> Wi-Fi)
  Future<http.Response> _sendPostWithFallback(
    String url,
    Map<String, dynamic> body,
  ) async {
    final candidateHosts = <String>[
      ApiConfig.activeHost,
      if (ApiConfig.activeHost == ApiConfig.usbPhysicalHost)
        ApiConfig.wifiLanHost
      else
        ApiConfig.usbPhysicalHost,
    ];

    Object? lastError;
    for (int i = 0; i < candidateHosts.length; i++) {
      final host = candidateHosts[i];
      final targetUrl = url.replaceFirst(ApiConfig.activeHost, host);
      try {
        final timeout = (i == 0)
            ? const Duration(seconds: 4)
            : const Duration(seconds: 8);

        final response = await _client
            .post(
              Uri.parse(targetUrl),
              headers: _buildHeaders(),
              body: jsonEncode(body),
            )
            .timeout(timeout);

        // Lock in the working host
        ApiConfig.activeHost = host;
        return response;
      } on SocketException catch (e) {
        lastError = e;
      } on TimeoutException catch (e) {
        lastError = e;
      }
    }

    if (lastError is TimeoutException) {
      throw ApiException(
        message: 'Connection timed out. Please check your network and ensure the backend is running.',
        errorCode: 'TIMEOUT',
        statusCode: 408,
      );
    }
    throw ApiException(
      message: 'Cannot connect to LifeUse backend at ${ApiConfig.activeHost}. Please ensure the server is running.',
      errorCode: 'NETWORK_ERROR',
      statusCode: 0,
    );
  }

  /// Helper to send GET with automatic host failover (USB <-> Wi-Fi)
  Future<http.Response> _sendGetWithFallback(String url) async {
    final candidateHosts = <String>[
      ApiConfig.activeHost,
      if (ApiConfig.activeHost == ApiConfig.usbPhysicalHost)
        ApiConfig.wifiLanHost
      else
        ApiConfig.usbPhysicalHost,
    ];

    Object? lastError;
    for (int i = 0; i < candidateHosts.length; i++) {
      final host = candidateHosts[i];
      final targetUrl = url.replaceFirst(ApiConfig.activeHost, host);
      try {
        final timeout = (i == 0)
            ? const Duration(seconds: 4)
            : const Duration(seconds: 8);

        final response = await _client
            .get(
              Uri.parse(targetUrl),
              headers: _buildHeaders(),
            )
            .timeout(timeout);

        // Lock in the working host
        ApiConfig.activeHost = host;
        return response;
      } on SocketException catch (e) {
        lastError = e;
      } on TimeoutException catch (e) {
        lastError = e;
      }
    }

    if (lastError is TimeoutException) {
      throw ApiException(
        message: 'Connection timed out. Please check your network and ensure the backend is running.',
        errorCode: 'TIMEOUT',
        statusCode: 408,
      );
    }
    throw ApiException(
      message: 'Cannot connect to LifeUse backend at ${ApiConfig.activeHost}. Please ensure the server is running.',
      errorCode: 'NETWORK_ERROR',
      statusCode: 0,
    );
  }

  /// Helper to send PUT with automatic host failover (USB <-> Wi-Fi)
  Future<http.Response> _sendPutWithFallback(
    String url,
    Map<String, dynamic> body,
  ) async {
    final candidateHosts = <String>[
      ApiConfig.activeHost,
      if (ApiConfig.activeHost == ApiConfig.usbPhysicalHost)
        ApiConfig.wifiLanHost
      else
        ApiConfig.usbPhysicalHost,
    ];

    Object? lastError;
    for (int i = 0; i < candidateHosts.length; i++) {
      final host = candidateHosts[i];
      final targetUrl = url.replaceFirst(ApiConfig.activeHost, host);
      try {
        final timeout = (i == 0)
            ? const Duration(seconds: 4)
            : const Duration(seconds: 8);

        final response = await _client
            .put(
              Uri.parse(targetUrl),
              headers: _buildHeaders(),
              body: jsonEncode(body),
            )
            .timeout(timeout);

        ApiConfig.activeHost = host;
        return response;
      } on SocketException catch (e) {
        lastError = e;
      } on TimeoutException catch (e) {
        lastError = e;
      }
    }

    if (lastError is TimeoutException) {
      throw ApiException(
        message: 'Connection timed out. Please check your network and ensure the backend is running.',
        errorCode: 'TIMEOUT',
        statusCode: 408,
      );
    }
    throw ApiException(
      message: 'Cannot connect to LifeUse backend at ${ApiConfig.activeHost}. Please ensure the server is running.',
      errorCode: 'NETWORK_ERROR',
      statusCode: 0,
    );
  }

  /// Helper to send DELETE with automatic host failover (USB <-> Wi-Fi)
  Future<http.Response> _sendDeleteWithFallback(String url) async {
    final candidateHosts = <String>[
      ApiConfig.activeHost,
      if (ApiConfig.activeHost == ApiConfig.usbPhysicalHost)
        ApiConfig.wifiLanHost
      else
        ApiConfig.usbPhysicalHost,
    ];

    Object? lastError;
    for (int i = 0; i < candidateHosts.length; i++) {
      final host = candidateHosts[i];
      final targetUrl = url.replaceFirst(ApiConfig.activeHost, host);
      try {
        final timeout = (i == 0)
            ? const Duration(seconds: 4)
            : const Duration(seconds: 8);

        final response = await _client
            .delete(
              Uri.parse(targetUrl),
              headers: _buildHeaders(),
            )
            .timeout(timeout);

        ApiConfig.activeHost = host;
        return response;
      } on SocketException catch (e) {
        lastError = e;
      } on TimeoutException catch (e) {
        lastError = e;
      }
    }

    if (lastError is TimeoutException) {
      throw ApiException(
        message: 'Connection timed out. Please check your network and ensure the backend is running.',
        errorCode: 'TIMEOUT',
        statusCode: 408,
      );
    }
    throw ApiException(
      message: 'Cannot connect to LifeUse backend at ${ApiConfig.activeHost}. Please ensure the server is running.',
      errorCode: 'NETWORK_ERROR',
      statusCode: 0,
    );
  }

  /// Execute HTTP POST request
  Future<ApiResponse<T>> post<T>({
    required String url,
    required Map<String, dynamic> body,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _sendPostWithFallback(url, body);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'An unexpected error occurred: ${e.toString()}',
        errorCode: 'UNKNOWN_ERROR',
        statusCode: 500,
      );
    }
  }

  /// Execute HTTP GET request
  Future<ApiResponse<T>> get<T>({
    required String url,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _sendGetWithFallback(url);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'An unexpected error occurred: ${e.toString()}',
        errorCode: 'UNKNOWN_ERROR',
        statusCode: 500,
      );
    }
  }

  /// Execute HTTP PUT request
  Future<ApiResponse<T>> put<T>({
    required String url,
    required Map<String, dynamic> body,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _sendPutWithFallback(url, body);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'An unexpected error occurred: ${e.toString()}',
        errorCode: 'UNKNOWN_ERROR',
        statusCode: 500,
      );
    }
  }

  /// Execute HTTP DELETE request
  Future<ApiResponse<T>> delete<T>({
    required String url,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _sendDeleteWithFallback(url);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'An unexpected error occurred: ${e.toString()}',
        errorCode: 'UNKNOWN_ERROR',
        statusCode: 500,
      );
    }
  }

  /// Parse response according to Spring Boot ApiResponse<T> contract
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic json)? fromJson,
  ) {
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = {'message': response.body};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return ApiResponse.fromJson(decoded, fromJson);
      }
      return ApiResponse<T>(
        success: true,
        message: 'Success',
        data: fromJson != null ? fromJson(decoded) : decoded as T?,
      );
    }

    // Handle 4xx / 5xx error responses from Spring Boot
    String errorMessage = 'Request failed with status ${response.statusCode}';
    String? errorCode;

    if (decoded is Map<String, dynamic>) {
      errorMessage = decoded['message']?.toString() ??
          decoded['error']?.toString() ??
          errorMessage;
      errorCode = decoded['errorCode']?.toString() ??
          decoded['status']?.toString();
    }

    throw ApiException(
      message: errorMessage,
      errorCode: errorCode,
      statusCode: response.statusCode,
    );
  }

  void dispose() {
    _client.close();
  }
}
