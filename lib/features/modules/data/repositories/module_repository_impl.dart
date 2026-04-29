import 'package:pr/core/errors/exceptions.dart';
import 'package:pr/core/storage/secure_storage.dart';
import 'package:pr/features/modules/data/datasources/module_remote_datasource.dart';
import 'package:pr/features/modules/domain/entities/module.dart';
import 'package:pr/features/modules/domain/repositories/module_repository.dart';

class ModuleRepositoryImpl implements ModuleRepository {
  final ModuleRemoteDataSource _remote;
  final SecureStorage _storage;
  ModuleRepositoryImpl(this._remote, this._storage);
  @override
  Future<List<Module>> getModules(String courseId) async {
    final t = await _storage.readAccessToken();
    if (t == null || t.isEmpty) {
      throw const AuthException('Access token topilmadi.');
    }
    return _remote.getModules(t, courseId);
  }
}
