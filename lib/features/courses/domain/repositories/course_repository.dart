import 'package:pr/features/courses/domain/entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();
  Future<Course> getCourseDetail(String id);
  Future<void> startCourse(String id);
  Future<Map<String, dynamic>> getCourseProgress(String id);
}
