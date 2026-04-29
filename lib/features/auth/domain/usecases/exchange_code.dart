import 'package:pr/features/auth/domain/entities/token_entity.dart';
import 'package:pr/features/auth/domain/repositories/auth_repository.dart';

class ExchangeCode {
  final AuthRepository _repository;
  ExchangeCode(this._repository);

  Future<TokenEntity> call(String code) => _repository.exchangeCode(code);
}
