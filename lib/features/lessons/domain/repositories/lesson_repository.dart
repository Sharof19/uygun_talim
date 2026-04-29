import 'package:pr/features/lessons/domain/entities/lesson.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getLessons(String moduleId);
}
