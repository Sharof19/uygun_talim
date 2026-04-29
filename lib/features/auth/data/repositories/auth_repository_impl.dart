import 'package:pr/core/storage/secure_storage.dart';
import 'package:pr/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pr/features/auth/domain/entities/token_entity.dart';
import 'package:pr/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final SecureStorage _storage;

  AuthRepositoryImpl(this._remote, this._storage);

  @override
  Future<String> getAuthorizationUrl() => _remote.getAuthorizationUrl();

  @override
  Future<TokenEntity> exchangeCode(String code) async {
    final token = await _remote.exchangeCode(code);
    await _storage.saveTokens(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
    );
    return token;
  }
}
