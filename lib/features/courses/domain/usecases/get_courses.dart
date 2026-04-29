import 'package:pr/features/courses/domain/entities/course.dart';
import 'package:pr/features/courses/domain/repositories/course_repository.dart';

class GetCourses {
  final CourseRepository _repository;
  GetCourses(this._repository);
  Future<List<Course>> call() => _repository.getCourses();
}
