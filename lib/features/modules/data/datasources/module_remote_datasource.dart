import 'package:pr/core/network/api_client.dart';
import 'package:pr/features/modules/data/models/module_model.dart';

abstract class ModuleRemoteDataSource {
  Future<List<ModuleModel>> getModules(String token, String courseId);
}

class ModuleRemoteDataSourceImpl implements ModuleRemoteDataSource {
  final ApiClient _client;
  ModuleRemoteDataSourceImpl(this._client);
  @override
  Future<List<ModuleModel>> getModules(String token, String courseId) async {
    final list = await _client.getList(
      '\${ApiConstants.modules}/',
      token: token,
      queryParams: {'course': courseId},
    );
    final models = list.map(ModuleModel.fromMap).toList()
      ..sort((a, b) {
        final o = a.order.compareTo(b.order);
        return o != 0 ? o : a.title.compareTo(b.title);
      });
    return models;
  }
}
