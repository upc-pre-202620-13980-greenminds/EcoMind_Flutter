enum AuthError {
  invalidCredentials,
  notParent,
  emailConflict,
  passwordPolicy,
  codeInvalid,
  codeExpired,
  tooManyAttempts,
  // The password reset link is malformed, expired or was already used
  resetTokenInvalid,
  // The backend could not send the email
  emailDelivery,
  connection,
  unknown,
}

class AuthException implements Exception {
  final AuthError error;

  const new(this.error);

  @override
  String toString() => 'AuthException($error)';
}
