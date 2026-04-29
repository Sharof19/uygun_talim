class TokenEntity {
  final String accessToken;
  final String? refreshToken;

  const TokenEntity({required this.accessToken, this.refreshToken});
}
