import 'package:pr/features/lessons/domain/entities/lesson.dart';
import 'package:pr/features/lessons/domain/repositories/lesson_repository.dart';

class GetLessons {
  final LessonRepository _r;
  GetLessons(this._r);
  Future<List<Lesson>> call(String moduleId) => _r.getLessons(moduleId);
}
