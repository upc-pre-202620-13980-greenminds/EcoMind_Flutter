import 'dart:convert';

import 'package:http/http.dart' as http;

// Error returned by the backend as {"code": ..., "message": ...}
class ApiException implements Exception {
  final int statusCode;
  final String code;
  final String message;

  const ApiException({
    required this.statusCode,
    required this.code,
    required this.message,
  });

  factory ApiException.fromResponse(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      if (json is Map<String, dynamic>) {
        return ApiException(
          statusCode: response.statusCode,
          code: json['code'] as String? ?? unknownCode,
          message: json['message'] as String? ?? '',
        );
      }
    } on FormatException {
      // The body is empty or is not JSON
    }
    return ApiException(
      statusCode: response.statusCode,
      code: unknownCode,
      message: response.body,
    );
  }

  static const String unknownCode = 'UNKNOWN';

  @override
  String toString() => 'ApiException($statusCode, $code): $message';
}
