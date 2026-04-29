import 'package:pr/features/auth/domain/entities/token_entity.dart';

class TokenModel extends TokenEntity {
  const TokenModel({required super.accessToken, super.refreshToken});

  factory TokenModel.fromMap(Map<String, dynamic> map) {
    String? access;
    String? refresh;

    void read(Map<String, dynamic> source) {
      access ??=
          source['access'] as String? ??
          source['access_token'] as String? ??
          source['token'] as String?;
      refresh ??=
          source['refresh'] as String? ?? source['refresh_token'] as String?;
    }

    read(map);

    final rootTokens = map['tokens'];
    if (rootTokens is Map<String, dynamic>) read(rootTokens);

    final data = map['data'];
    if (data is Map<String, dynamic>) {
      read(data);
      final dataTokens = data['tokens'];
      if (dataTokens is Map<String, dynamic>) read(dataTokens);
    }

    if (access == null || access!.isEmpty) {
      throw Exception('Token topilmadi. Iltimos, qayta urinib ko\'ring.');
    }

    return TokenModel(accessToken: access!, refreshToken: refresh);
  }
}
