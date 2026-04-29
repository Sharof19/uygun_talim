import 'package:pr/features/courses/domain/repositories/course_repository.dart';

class StartCourse {
  final CourseRepository _repository;
  StartCourse(this._repository);
  Future<void> call(String id) => _repository.startCourse(id);
}
