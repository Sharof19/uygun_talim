import 'dart:convert';

import 'package:http/http.dart' as http;

class CourseCategory {
  CourseCategory({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
  });

  final String id;
  final String title;
  final String slug;
  final String description;

  factory CourseCategory.fromMap(Map<String, dynamic> data) {
    return CourseCategory(
      id: (data['id'] ?? '').toString(),
      title: (data['title'] ?? '').toString(),
      slug: (data['slug'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
    );
  }
}

class CourseAuthor {
  CourseAuthor({required this.id, required this.firstName});

  final String id;
  final String firstName;

  factory CourseAuthor.fromMap(Map<String, dynamic> data) {
    return CourseAuthor(
      id: (data['id'] ?? '').toString(),
      firstName: (data['first_name'] ?? '').toString(),
    );
  }
}

class CourseEnrollment {
  CourseEnrollment({
    required this.id,
    required this.isPaid,
    required this.paymentDate,
  });

  final String id;
  final bool isPaid;
  final String paymentDate;

  factory CourseEnrollment.fromMap(Map<String, dynamic> data) {
    return CourseEnrollment(
      id: (data['id'] ?? '').toString(),
      isPaid: data['is_paid'] == true,
      paymentDate: (data['payment_date'] ?? '').toString(),
    );
  }
}

class Course {
  Course({
    required this.id,
    required this.title,
    required this.slug,
    required this.image,
    required this.description,
    required this.subject,
    required this.category,
    required this.author,
    required this.isPaid,
    required this.price,
    required this.currency,
    required this.progress,
    required this.isPublished,
    required this.modulesCount,
    required this.enrollment,
  });

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

  factory Course.fromMap(Map<String, dynamic> data) {
    final categoryRaw = data['category'];
    final authorRaw = data['author'];
    final enrollmentRaw = data['enrollment'];

    return Course(
      id: (data['id'] ?? '').toString(),
      title: (data['title'] ?? '').toString(),
      slug: (data['slug'] ?? '').toString(),
      image: (data['image'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      subject: (data['subject'] ?? '').toString(),
      category:
          categoryRaw is Map<String, dynamic> ? CourseCategory.fromMap(categoryRaw) : null,
      author:
          authorRaw is Map<String, dynamic> ? CourseAuthor.fromMap(authorRaw) : null,
      isPaid: data['is_paid'] == true,
      price: (data['price'] ?? '').toString(),
      currency: (data['currency'] ?? '').toString(),
      progress: _parseInt(data['progress']),
      isPublished: data['is_published'] == true,
      modulesCount: _parseInt(data['modules_count']),
      enrollment: enrollmentRaw is Map<String, dynamic>
          ? CourseEnrollment.fromMap(enrollmentRaw)
          : null,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class CourseService {
  CourseService({
    http.Client? client,
    this.baseUrl = 'https://api.uyguntalim.tsue.uz/api',
    this.csrfToken = 'x9Jv5GBLMZLVyTRu6rFmF2b8uORvppSDOHtWzbixuyB9RmgznaYKyNpuBDv3eOSb',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final String csrfToken;

  Future<List<Course>> fetchCourses(String accessToken) async {
    final uri = Uri.parse('$baseUrl/courses/');
    final response = await _client.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'X-CSRFTOKEN': csrfToken,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: 'Kurslarni olishda xatolik yuz berdi.',
        ),
      );
    }

    final decoded = _decodeList(response.body);
    return decoded.map(Course.fromMap).toList();
  }

  Future<Course> fetchCourseDetail(String accessToken, String id) async {
    final uri = Uri.parse('$baseUrl/courses/$id/');
    final response = await _client.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'X-CSRFTOKEN': csrfToken,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: 'Kurs maʼlumotlarini olishda xatolik yuz berdi.',
        ),
      );
    }

    final decoded = _decodeMap(response.body);
    return Course.fromMap(decoded);
  }

  Future<void> startCourse(String accessToken, String id) async {
    final uri = Uri.parse('$baseUrl/courses/$id/start/');
    final response = await _client.post(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'X-CSRFTOKEN': csrfToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: 'Kursni boshlashda xatolik yuz berdi.',
        ),
      );
    }
  }

  Future<Map<String, dynamic>> fetchCourseProgress(
    String accessToken,
    String id,
  ) async {
    final uri = Uri.parse('$baseUrl/courses/$id/progress/');
    final response = await _client.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'X-CSRFTOKEN': csrfToken,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: 'Progressni olishda xatolik yuz berdi.',
        ),
      );
    }

    return _decodeMap(response.body);
  }

  List<Map<String, dynamic>> _decodeList(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .toList();
      }
      if (decoded is Map<String, dynamic>) {
        final results = decoded['results'];
        if (results is List) {
          return results.whereType<Map<String, dynamic>>().toList();
        }
        final data = decoded['data'];
        if (data is List) {
          return data.whereType<Map<String, dynamic>>().toList();
        }
      }
    } catch (_) {}
    return <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _decodeMap(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final data = decoded['data'];
        if (data is Map<String, dynamic> && data.containsKey('id')) {
          return data;
        }
        return decoded;
      }
    } catch (_) {}
    return <String, dynamic>{};
  }

  String _extractErrorMessage(String body, {required String fallback}) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'] as String?;
        if (message != null && message.isNotEmpty) return message;
        final detail = decoded['detail'] as String?;
        if (detail != null && detail.isNotEmpty) return detail;
        final errorDescription = decoded['error_description'] as String?;
        if (errorDescription != null && errorDescription.isNotEmpty) return errorDescription;
        final error = decoded['error'] as String?;
        if (error != null && error.isNotEmpty) return error;
        final nonFieldErrors = decoded['non_field_errors'];
        if (nonFieldErrors is List && nonFieldErrors.isNotEmpty) {
          final text = nonFieldErrors.first.toString();
          if (text.isNotEmpty) return text;
        }
      }
    } catch (_) {}
    return fallback;
  }
}
