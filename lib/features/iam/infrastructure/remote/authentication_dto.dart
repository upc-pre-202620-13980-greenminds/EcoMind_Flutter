class AuthenticationDto {
  final String accessToken;
  final String expiresAt;
  final int accountId;
  final String email;

  const new({
    required this.accessToken,
    required this.expiresAt,
    required this.accountId,
    required this.email,
  });

  factory AuthenticationDto.fromJson(Map<String, dynamic> json) {
    return AuthenticationDto(
      accessToken: json['accessToken'],
      expiresAt: json['expiresAt'],
      accountId: json['accountId'],
      email: json['email'],
    );
  }
}
