import 'package:pr/core/errors/exceptions.dart';
import 'package:pr/core/storage/secure_storage.dart';
import 'package:pr/features/courses/data/datasources/course_remote_datasource.dart';
import 'package:pr/features/courses/domain/entities/course.dart';
import 'package:pr/features/courses/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource _remote;
  final SecureStorage _storage;

  CourseRepositoryImpl(this._remote, this._storage);

  Future<String> _token() async {
    final token = await _storage.readAccessToken();
    if (token == null || token.isEmpty) {
      throw const AuthException('Access token topilmadi.');
    }
    return token;
  }

  @override
  Future<List<Course>> getCourses() async => _remote.getCourses(await _token());

  @override
  Future<Course> getCourseDetail(String id) async =>
      _remote.getCourseDetail(await _token(), id);

  @override
  Future<void> startCourse(String id) async =>
      _remote.startCourse(await _token(), id);

  @override
  Future<Map<String, dynamic>> getCourseProgress(String id) async =>
      _remote.getCourseProgress(await _token(), id);
}
