class ApiConfig {
  // Set with --dart-define=API_BASE_URL=...; the default points to the backend
  // running on the computer, as seen from the Android emulator
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8092',
  );

  // The hosted backend can take a while to wake up
  static const Duration timeout = Duration(seconds: 60);

  static Uri uri(String path, [Map<String, String>? queryParameters]) {
    return Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
  }
}
