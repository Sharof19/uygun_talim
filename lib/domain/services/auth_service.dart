import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  AuthService({
    http.Client? client,
    this.baseUrl = 'https://api.uyguntalim.tsue.uz/api-v1',
    this.csrfToken =
        'x9Jv5GBLMZLVyTRu6rFmF2b8uORvppSDOHtWzbixuyB9RmgznaYKyNpuBDv3eOSb',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final String csrfToken;
  int? _lastStudentCallbackStatusCode;
  String? _lastStudentCallbackBody;

  int? get lastStudentCallbackStatusCode => _lastStudentCallbackStatusCode;
  String? get lastStudentCallbackBody => _lastStudentCallbackBody;

  Future<String> fetchAuthorizationUrl() async {
    final endpoints = <String>[
      'authorization-mobil-student',
      'authorization-mobil-student/',
    ];
    http.Response? response;

    for (final endpoint in endpoints) {
      final currentResponse = await _client.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'accept': 'application/json', 'X-CSRFTOKEN': csrfToken},
      );
      response = currentResponse;
      if (currentResponse.statusCode != 404) {
        break;
      }
    }

    if (response == null) {
      throw Exception('Kirish uchun havola olinmadi.');
    }

    final body = _decodeBody(response.body);
    if (response.statusCode == 200) {
      final directUrl = body['authorization_url'] as String?;
      if (directUrl != null && directUrl.isNotEmpty) {
        return directUrl;
      }
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        final url = data['authorization_url'] as String?;
        if (url != null && url.isNotEmpty) {
          return url;
        }
      }
      throw Exception('Authorization URL topilmadi.');
    }

    throw Exception(
      _extractErrorMessage(body, fallback: 'Kirish uchun havola olinmadi.'),
    );
  }

  Future<Map<String, dynamic>> exchangeCode(String code) async {
    final callbackEndpoints = <String>[
      'student-mobil-callback/',
      'student-mobil-callback',
      'student-callback/',
      'student-callback',
    ];
    http.Response? response;

    for (final endpoint in callbackEndpoints) {
      final uri = Uri.parse(
        '$baseUrl/$endpoint',
      ).replace(queryParameters: {'code': code});
      final currentResponse = await _client.get(
        uri,
        headers: {'accept': 'application/json', 'X-CSRFTOKEN': csrfToken},
      );

      _lastStudentCallbackStatusCode = currentResponse.statusCode;
      _lastStudentCallbackBody = currentResponse.body;
      response = currentResponse;

      if (currentResponse.statusCode != 404) {
        break;
      }
    }

    if (response == null) {
      throw Exception('Kodni tekshirishda xatolik yuz berdi.');
    }

    final body = _decodeBody(response.body);
    if (response.statusCode == 200) {
      return body;
    }

    throw Exception(
      _extractErrorMessage(
        body,
        fallback: 'Kodni tekshirishda xatolik yuz berdi.',
      ),
    );
  }

  Map<String, dynamic> _decodeBody(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return <String, dynamic>{};
  }

  String _extractErrorMessage(
    Map<String, dynamic> body, {
    required String fallback,
  }) {
    final message = body['message'] as String?;
    if (message != null && message.isNotEmpty) {
      return message;
    }

    final description = body['error_description'] as String?;
    if (description != null && description.isNotEmpty) {
      return description;
    }

    final error = body['error'] as String?;
    if (error != null && error.isNotEmpty) {
      return error;
    }

    return fallback;
  }
}
