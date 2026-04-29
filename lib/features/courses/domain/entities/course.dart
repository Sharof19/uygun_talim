class CourseCategory {
  final String id;
  final String title;
  final String slug;
  final String description;
  const CourseCategory({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
  });
}

class CourseAuthor {
  final String id;
  final String firstName;
  const CourseAuthor({required this.id, required this.firstName});
}

class CourseEnrollment {
  final String id;
  final bool isPaid;
  final String paymentDate;
  const CourseEnrollment({
    required this.id,
    required this.isPaid,
    required this.paymentDate,
  });
}

class Course {
  final String id;
  final String title;
  final String slug;
  final String image;
  final String description;
  final String subject;
  final CourseCategory? category;
  final CourseAuthor? author;
  final bool isPaid;
  final String price;
  final String currency;
  final int progress;
  final bool isPublished;
  final int modulesCount;
  final CourseEnrollment? enrollment;

  const Course({
    required this.id,
    required this.title,
    required this.slug,
    required this.image,
    required this.description,
    required this.subject,
    this.category,
    this.author,
    required this.isPaid,
    required this.price,
    required this.currency,
    required this.progress,
    required this.isPublished,
    required this.modulesCount,
    this.enrollment,
  });
}
