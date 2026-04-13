import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pr/domain/services/api_parsing.dart';

class TestItem {
  TestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.questionsCount,
    required this.raw,
  });

  final String id;
  final String title;
  final String description;
  final int duration;
  final int questionsCount;
  final Map<String, dynamic> raw;

  factory TestItem.fromMap(Map<String, dynamic> data) {
    return TestItem(
      id: (data['id'] ?? '').toString(),
      title: (data['title'] ?? data['name'] ?? data['subject'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      duration: _parseInt(data['duration'] ?? data['time']),
      questionsCount: _parseInt(data['questions_count'] ?? data['questionsCount']),
      raw: data,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class TestService with ApiParsing {
  TestService({
    http.Client? client,
    this.baseUrl = 'https://api.uyguntalim.tsue.uz/api',
    this.csrfToken = 'x9Jv5GBLMZLVyTRu6rFmF2b8uORvppSDOHtWzbixuyB9RmgznaYKyNpuBDv3eOSb',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final String csrfToken;

  Future<List<TestItem>> fetchTests(String accessToken) async {
    final uri = Uri.parse('$baseUrl/tests/');
    final response = await _client.get(uri, headers: _headers(accessToken));
    if (response.statusCode != 200) {
      throw Exception(
        extractErrorMessage(
          response.body,
          fallback: 'Testlarni olishda xatolik yuz berdi.',
        ),
      );
    }
    final decoded = decodeList(response.body);
    return decoded.map(TestItem.fromMap).toList();
  }

  Future<Map<String, dynamic>> fetchTest(
    String accessToken,
    String id,
  ) async {
    final uri = Uri.parse('$baseUrl/tests/$id/');
    final response = await _client.get(uri, headers: _headers(accessToken));
    if (response.statusCode != 200) {
      throw Exception(
        extractErrorMessage(
          response.body,
          fallback: 'Test maʼlumotlarini olishda xatolik yuz berdi.',
        ),
      );
    }
    return decodeMap(response.body);
  }

  Future<Map<String, dynamic>> submitTest(
    String accessToken,
    String id,
    Map<String, dynamic> payload,
  ) async {
    final uri = Uri.parse('$baseUrl/tests/$id/submit/');
    final response = await _client.post(
      uri,
      headers: {
        ..._headers(accessToken),
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        extractErrorMessage(
          response.body,
          fallback: 'Testni yuborishda xatolik yuz berdi.',
        ),
      );
    }
    return decodeMap(response.body);
  }

  Map<String, String> _headers(String accessToken) {
    return {
      'accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'X-CSRFTOKEN': csrfToken,
    };
  }
}
