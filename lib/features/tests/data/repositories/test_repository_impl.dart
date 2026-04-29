import 'package:pr/core/errors/exceptions.dart';
import 'package:pr/core/storage/secure_storage.dart';
import 'package:pr/features/tests/data/datasources/test_remote_datasource.dart';
import 'package:pr/features/tests/domain/entities/test_item.dart';
import 'package:pr/features/tests/domain/repositories/test_repository.dart';

class TestRepositoryImpl implements TestRepository {
  final TestRemoteDataSource _remote;
  final SecureStorage _storage;
  TestRepositoryImpl(this._remote, this._storage);
  Future<String> _token() async {
    final t = await _storage.readAccessToken();
    if (t == null || t.isEmpty) {
      throw const AuthException('Access token topilmadi.');
    }
    return t;
  }

  @override
  Future<List<TestItem>> getTests() async => _remote.getTests(await _token());
  @override
  Future<Map<String, dynamic>> getTestDetail(String id) async =>
      _remote.getTestDetail(await _token(), id);
  @override
  Future<Map<String, dynamic>> submitTest(
    String id,
    Map<String, dynamic> payload,
  ) async => _remote.submitTest(await _token(), id, payload);
}
