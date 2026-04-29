import 'package:pr/core/constants/api_constants.dart';
import 'package:pr/core/network/api_client.dart';
import 'package:pr/features/auth/data/models/token_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> getAuthorizationUrl();
  Future<TokenModel> exchangeCode(String code);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _client;
  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<String> getAuthorizationUrl() async {
    final data = await _client.getMapWithFallback([
      '${ApiConstants.authorizationUrl}/',
      ApiConstants.authorizationUrl,
    ]);

    final url =
        data['authorization_url'] as String? ??
        (data['data'] as Map<String, dynamic>?)?['authorization_url']
            as String?;

    if (url == null || url.isEmpty) {
      throw Exception('Authorization URL topilmadi.');
    }
    return url;
  }

  @override
  Future<TokenModel> exchangeCode(String code) async {
    final data = await _client.getMapWithFallback([
      '${ApiConstants.studentCallback}/?code=$code',
      '${ApiConstants.apiV1}/student-callback/?code=$code',
    ]);
    return TokenModel.fromMap(data);
  }
}
