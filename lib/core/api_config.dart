class ApiConfig {
  // Override with --dart-define=API_BASE_URL=... for local development.
  // The default uses the public Azure backend.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://ca-ecomind-api.icybush-bd135296.westus2.azurecontainerapps.io',
  );

  // Allow the first request to include a Container Apps cold start.
  static const Duration timeout = Duration(seconds: 120);

  static Uri uri(String path, [Map<String, String>? queryParameters]) {
    return Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
  }
}
