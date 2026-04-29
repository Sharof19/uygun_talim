import 'package:pr/features/courses/domain/entities/course.dart';

class CourseCategoryModel extends CourseCategory {
  const CourseCategoryModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.description,
  });

  factory CourseCategoryModel.fromMap(Map<String, dynamic> d) =>
      CourseCategoryModel(
        id: (d['id'] ?? '').toString(),
        title: (d['title'] ?? '').toString(),
        slug: (d['slug'] ?? '').toString(),
        description: (d['description'] ?? '').toString(),
      );
}

class CourseAuthorModel extends CourseAuthor {
  const CourseAuthorModel({required super.id, required super.firstName});

  factory CourseAuthorModel.fromMap(Map<String, dynamic> d) =>
      CourseAuthorModel(
        id: (d['id'] ?? '').toString(),
        firstName: (d['first_name'] ?? '').toString(),
      );
}

class CourseEnrollmentModel extends CourseEnrollment {
  const CourseEnrollmentModel({
    required super.id,
    required super.isPaid,
    required super.paymentDate,
  });

  factory CourseEnrollmentModel.fromMap(Map<String, dynamic> d) =>
      CourseEnrollmentModel(
        id: (d['id'] ?? '').toString(),
        isPaid: d['is_paid'] == true,
        paymentDate: (d['payment_date'] ?? '').toString(),
      );
}

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.image,
    required super.description,
    required super.subject,
    super.category,
    super.author,
    required super.isPaid,
    required super.price,
    required super.currency,
    required super.progress,
    required super.isPublished,
    required super.modulesCount,
    super.enrollment,
  });

  factory CourseModel.fromMap(Map<String, dynamic> d) {
    return CourseModel(
      id: (d['id'] ?? '').toString(),
      title: (d['title'] ?? '').toString(),
      slug: (d['slug'] ?? '').toString(),
      image: (d['image'] ?? '').toString(),
      description: (d['description'] ?? '').toString(),
      subject: (d['subject'] ?? '').toString(),
      category: d['category'] is Map<String, dynamic>
          ? CourseCategoryModel.fromMap(d['category'])
          : null,
      author: d['author'] is Map<String, dynamic>
          ? CourseAuthorModel.fromMap(d['author'])
          : null,
      isPaid: d['is_paid'] == true,
      price: (d['price'] ?? '').toString(),
      currency: (d['currency'] ?? '').toString(),
      progress: _parseInt(d['progress']),
      isPublished: d['is_published'] == true,
      modulesCount: _parseInt(d['modules_count']),
      enrollment: d['enrollment'] is Map<String, dynamic>
          ? CourseEnrollmentModel.fromMap(d['enrollment'])
          : null,
    );
  }

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
