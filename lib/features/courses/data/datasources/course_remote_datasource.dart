import 'package:pr/core/constants/api_constants.dart';
import 'package:pr/core/network/api_client.dart';
import 'package:pr/features/courses/data/models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses(String token);
  Future<CourseModel> getCourseDetail(String token, String id);
  Future<void> startCourse(String token, String id);
  Future<Map<String, dynamic>> getCourseProgress(String token, String id);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiClient _client;
  CourseRemoteDataSourceImpl(this._client);

  @override
  Future<List<CourseModel>> getCourses(String token) async {
    final list = await _client.getList(
      '${ApiConstants.courses}/',
      token: token,
    );
    return list.map(CourseModel.fromMap).toList();
  }

  @override
  Future<CourseModel> getCourseDetail(String token, String id) async {
    final map = await _client.getMap(
      '${ApiConstants.courses}/$id/',
      token: token,
    );
    return CourseModel.fromMap(map);
  }

  @override
  Future<void> startCourse(String token, String id) async {
    await _client.post('${ApiConstants.courses}/$id/start/', token: token);
  }

  @override
  Future<Map<String, dynamic>> getCourseProgress(
    String token,
    String id,
  ) async {
    return _client.getMap(
      '${ApiConstants.courses}/$id/progress/',
      token: token,
    );
  }
}
