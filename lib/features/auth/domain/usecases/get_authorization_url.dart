import 'package:pr/features/auth/domain/repositories/auth_repository.dart';

class GetAuthorizationUrl {
  final AuthRepository _repository;
  GetAuthorizationUrl(this._repository);

  Future<String> call() => _repository.getAuthorizationUrl();
}
