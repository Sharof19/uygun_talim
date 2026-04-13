import 'package:http/http.dart' as http;
import 'package:pr/domain/services/api_parsing.dart';

class Module {
  Module({
    required this.id,
    required this.title,
    required this.order,
    required this.lessonsCount,
    required this.raw,
  });

  final String id;
  final String title;
  final int order;
  final int lessonsCount;
  final Map<String, dynamic> raw;

  factory Module.fromMap(Map<String, dynamic> data) {
    final order = _parseInt(data['order'] ?? data['position'] ?? data['index']);
    final lessonsCount = _parseInt(
      data['lessons_count'] ?? data['lesson_count'] ?? data['lessons'],
    );
    return Module(
      id: (data['id'] ?? '').toString(),
      title: (data['title'] ?? data['name'] ?? '').toString(),
      order: order,
      lessonsCount: lessonsCount,
      raw: data,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ModuleService with ApiParsing {
  ModuleService({
    http.Client? client,
    this.baseUrl = 'https://api.uyguntalim.tsue.uz/api',
    this.csrfToken = 'x9Jv5GBLMZLVyTRu6rFmF2b8uORvppSDOHtWzbixuyB9RmgznaYKyNpuBDv3eOSb',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final String csrfToken;

  Future<List<Module>> fetchModules(
    String accessToken, {
    required String courseId,
  }) async {
    final uri = Uri.parse('$baseUrl/modules/').replace(
      queryParameters: {
        'course': courseId,
      },
    );
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
        extractErrorMessage(
          response.body,
          fallback: 'Modullarni olishda xatolik yuz berdi.',
        ),
      );
    }

    final decoded = decodeList(response.body);
    final modules = decoded.map(Module.fromMap).toList()
      ..sort((a, b) {
        final byOrder = a.order.compareTo(b.order);
        if (byOrder != 0) return byOrder;
        return a.title.compareTo(b.title);
      });
    return modules;
  }
}
