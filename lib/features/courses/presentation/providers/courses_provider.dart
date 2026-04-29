import 'package:flutter/material.dart';
import 'package:pr/features/courses/domain/entities/course.dart';
import 'package:pr/features/courses/domain/usecases/get_course_detail.dart';
import 'package:pr/features/courses/domain/usecases/get_courses.dart';
import 'package:pr/features/courses/domain/usecases/start_course.dart';

class CoursesProvider extends ChangeNotifier {
  final GetCourses _getCourses;

  CoursesProvider(this._getCourses);

  bool isLoading = false;
  String? errorMessage;
  List<Course> courses = [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      courses = await _getCourses();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class CourseDetailProvider extends ChangeNotifier {
  final GetCourseDetail _getCourseDetail;
  final StartCourse _startCourse;

  CourseDetailProvider(this._getCourseDetail, this._startCourse);

  bool isLoading = false;
  bool isStarting = false;
  String? errorMessage;
  Course? course;

  Future<void> load(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      course = await _getCourseDetail(id);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> start(String id) async {
    isStarting = true;
    notifyListeners();
    try {
      await _startCourse(id);
      await load(id);
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      isStarting = false;
      notifyListeners();
    }
  }
}
