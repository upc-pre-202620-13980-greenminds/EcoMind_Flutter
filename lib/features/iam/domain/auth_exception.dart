enum AuthError {
  invalidCredentials,
  notParent,
  emailConflict,
  passwordPolicy,
  codeInvalid,
  codeExpired,
  tooManyAttempts,
  connection,
  unknown,
}

class AuthException implements Exception {
  final AuthError error;

  const new(this.error);

  @override
  String toString() => 'AuthException($error)';
}
