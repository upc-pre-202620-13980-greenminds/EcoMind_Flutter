// Link of the password reset email: ecomind://authentication/reset-password?token=...
// Only this exact route is accepted; no other parameter is used or followed.
abstract final class PasswordResetLink {
  static const String scheme = 'ecomind';
  static const String host = 'authentication';
  static const String path = '/reset-password';
  static const String tokenParameter = 'token';

  // Name of the route that shows the reset screen; it never contains the token
  static const String routeName = '/password-reset';

  // The backend generates 32 random bytes encoded as base64url without padding
  static final RegExp _tokenPattern = RegExp(r'^[A-Za-z0-9_-]{43}$');

  // True for any link to the reset route, even when its token is not valid,
  // so the app can explain that the link is broken instead of ignoring it
  static bool matches(Uri uri) {
    return uri.scheme == scheme && uri.host == host && uri.path == path;
  }

  // The token of a well formed link, or null when the link must not be used
  static String? tokenFrom(Uri uri) {
    if (!matches(uri) ||
        uri.userInfo.isNotEmpty ||
        uri.hasPort ||
        uri.hasFragment) {
      return null;
    }

    List<String>? values;
    try {
      // Decoding fails on malformed percent escapes
      values = uri.queryParametersAll[tokenParameter];
    } on FormatException {
      return null;
    } on ArgumentError {
      return null;
    }
    if (values == null || values.length != 1) {
      return null;
    }

    final token = values.single;
    return _tokenPattern.hasMatch(token) ? token : null;
  }
}
