import 'package:pr/core/constants/api_constants.dart';
import 'package:pr/core/network/api_client.dart';
import 'package:pr/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String token);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _client;
  ProfileRemoteDataSourceImpl(this._client);
  @override
  Future<ProfileModel> getProfile(String token) async {
    final map = await _client.getMapWithFallback([
      '\${ApiConstants.accountMe}/',
      ApiConstants.accountMe,
    ], token: token);
    return ProfileModel.fromMap(map);
  }
}
