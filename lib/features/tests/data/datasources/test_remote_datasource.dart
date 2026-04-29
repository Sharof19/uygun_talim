import 'package:pr/core/network/api_client.dart';
import 'package:pr/features/tests/data/models/test_model.dart';

abstract class TestRemoteDataSource {
  Future<List<TestModel>> getTests(String token);
  Future<Map<String, dynamic>> getTestDetail(String token, String id);
  Future<Map<String, dynamic>> submitTest(
    String token,
    String id,
    Map<String, dynamic> payload,
  );
}

class TestRemoteDataSourceImpl implements TestRemoteDataSource {
  final ApiClient _client;
  TestRemoteDataSourceImpl(this._client);
  @override
  Future<List<TestModel>> getTests(String token) async {
    final list = await _client.getList('\${ApiConstants.tests}/', token: token);
    return list.map(TestModel.fromMap).toList();
  }

  @override
  Future<Map<String, dynamic>> getTestDetail(String token, String id) =>
      _client.getMap('\${ApiConstants.tests}/\$id/', token: token);
  @override
  Future<Map<String, dynamic>> submitTest(
    String token,
    String id,
    Map<String, dynamic> payload,
  ) => _client.post(
    '\${ApiConstants.tests}/\$id/submit/',
    token: token,
    body: payload,
  );
}
