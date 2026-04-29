import 'package:pr/features/auth/domain/entities/token_entity.dart';

abstract class AuthRepository {
  Future<String> getAuthorizationUrl();
  Future<TokenEntity> exchangeCode(String code);
}
