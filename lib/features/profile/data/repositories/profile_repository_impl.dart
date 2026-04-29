import 'package:pr/core/errors/exceptions.dart';
import 'package:pr/core/storage/secure_storage.dart';
import 'package:pr/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:pr/features/profile/domain/entities/profile.dart';
import 'package:pr/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remote;
  final SecureStorage _storage;
  ProfileRepositoryImpl(this._remote, this._storage);
  @override
  Future<Profile> getProfile() async {
    final token = await _storage.readAccessToken();
    if (token == null || token.isEmpty) {
      throw const AuthException('Access token topilmadi.');
    }
    return _remote.getProfile(token);
  }
}
