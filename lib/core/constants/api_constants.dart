abstract class ApiConstants {
  static const String baseUrl = 'https://api.uyguntalim.tsue.uz';
  static const String apiV1 = '$baseUrl/api-v1';
  static const String api = '$baseUrl/api';

  static const String csrfToken =
      'x9Jv5GBLMZLVyTRu6rFmF2b8uORvppSDOHtWzbixuyB9RmgznaYKyNpuBDv3eOSb';

  // Auth endpoints
  static const String authorizationUrl = '$apiV1/authorization-mobil-student';
  static const String studentCallback = '$apiV1/student-mobil-callback';

  // API endpoints
  static const String courses = '$api/courses';
  static const String modules = '$api/modules';
  static const String lessons = '$api/lessons';
  static const String categories = '$api/categories';
  static const String certificates = '$api/certificates';
  static const String payments = '$api/payments';
  static const String tests = '$api/tests';
  static const String accountMe = '$apiV1/account/me';
}
