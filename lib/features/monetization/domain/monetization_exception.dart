enum MonetizationError {
  sessionExpired,
  insufficientGems,
  alreadyOwned,
  notFound,
  connection,
  unknown,
}

class MonetizationException implements Exception {
  final MonetizationError error;
  const MonetizationException(this.error);
}
