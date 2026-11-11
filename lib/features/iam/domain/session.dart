class Session {
  final String accessToken;
  final DateTime expiresAt;
  final int accountId;

  const new({
    required this.accessToken,
    required this.expiresAt,
    required this.accountId,
  });

  bool isExpired(DateTime now) {
    return !now.isBefore(expiresAt);
  }
}
