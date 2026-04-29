import 'package:pr/core/network/api_client.dart';
import 'package:pr/features/lessons/data/models/lesson_model.dart';

abstract class LessonRemoteDataSource {
  Future<List<LessonModel>> getLessons(String token, String moduleId);
}

class LessonRemoteDataSourceImpl implements LessonRemoteDataSource {
  final ApiClient _client;
  LessonRemoteDataSourceImpl(this._client);
  @override
  Future<List<LessonModel>> getLessons(String token, String moduleId) async {
    final list = await _client.getList(
      '\${ApiConstants.lessons}/',
      token: token,
      queryParams: {'moduls': moduleId},
    );
    final models = list.map(LessonModel.fromMap).toList()
      ..sort((a, b) {
        final o = a.order.compareTo(b.order);
        return o != 0 ? o : a.title.compareTo(b.title);
      });
    return models;
  }
}
