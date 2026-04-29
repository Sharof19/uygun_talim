import 'package:pr/core/errors/exceptions.dart';
import 'package:pr/core/storage/secure_storage.dart';
import 'package:pr/features/lessons/data/datasources/lesson_remote_datasource.dart';
import 'package:pr/features/lessons/domain/entities/lesson.dart';
import 'package:pr/features/lessons/domain/repositories/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource _remote;
  final SecureStorage _storage;
  LessonRepositoryImpl(this._remote, this._storage);
  @override
  Future<List<Lesson>> getLessons(String moduleId) async {
    final t = await _storage.readAccessToken();
    if (t == null || t.isEmpty) {
      throw const AuthException('Access token topilmadi.');
    }
    return _remote.getLessons(t, moduleId);
  }
}
