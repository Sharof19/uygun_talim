import 'package:pr/features/courses/domain/entities/course.dart';
import 'package:pr/features/courses/domain/repositories/course_repository.dart';

class GetCourseDetail {
  final CourseRepository _repository;
  GetCourseDetail(this._repository);
  Future<Course> call(String id) => _repository.getCourseDetail(id);
}
