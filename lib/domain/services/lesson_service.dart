import 'package:http/http.dart' as http;
import 'package:pr/domain/services/api_parsing.dart';

class Lesson {
  Lesson({
    required this.id,
    required this.title,
    required this.order,
    required this.description,
    required this.videoSource,
    required this.raw,
  });

  final String id;
  final String title;
  final int order;
  final String description;
  final String videoSource;
  final Map<String, dynamic> raw;

  factory Lesson.fromMap(Map<String, dynamic> data) {
    return Lesson(
      id: (data['id'] ?? '').toString(),
      title: (data['title'] ?? data['name'] ?? '').toString(),
      order: _parseInt(data['order'] ?? data['position'] ?? data['index']),
      description: (data['description'] ?? data['content'] ?? '').toString(),
      videoSource: _normalizeMediaUrl(_extractVideoSource(data)),
      raw: data,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _extractVideoSource(Map<String, dynamic> data) {
    const keys = [
      'video',
      'video_url',
      'video_source',
      'video_file',
      'file',
      'url',
      'source',
      'media',
    ];

    for (final key in keys) {
      final value = data[key];
      final extracted = _extractString(value);
      if (extracted.isNotEmpty) return extracted;
    }

    for (final value in data.values) {
      final extracted = _extractString(value);
      if (extracted.isNotEmpty &&
          (extracted.contains('.mp4') ||
              extracted.contains('.m3u8') ||
              extracted.startsWith('http'))) {
        return extracted;
      }
    }

    return '';
  }

  static String _extractString(dynamic value) {
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      for (final nestedKey in ['url', 'file', 'video', 'src', 'source']) {
        final nested = value[nestedKey];
        if (nested is String && nested.isNotEmpty) {
          return nested;
        }
      }
    }
    return '';
  }

  static String _normalizeMediaUrl(String source) {
    var url = source.trim();
    if (url.isEmpty) return '';
    if (url.startsWith('/')) {
      return 'https://api.uyguntalim.tsue.uz$url';
    }
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://api.uyguntalim.tsue.uz/$url';
    }
    if (url.startsWith('http://api.uyguntalim.tsue.uz/')) {
      url = url.replaceFirst('http://', 'https://');
    }
    return url;
  }
}

class LessonService with ApiParsing {
  LessonService({
    http.Client? client,
    this.baseUrl = 'https://api.uyguntalim.tsue.uz/api',
    this.csrfToken = 'x9Jv5GBLMZLVyTRu6rFmF2b8uORvppSDOHtWzbixuyB9RmgznaYKyNpuBDv3eOSb',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final String csrfToken;

  Future<List<Lesson>> fetchLessons(
    String accessToken, {
    required String moduleId,
  }) async {
    final uri = Uri.parse('$baseUrl/lessons/').replace(
      queryParameters: {
        'moduls': moduleId,
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
          fallback: 'Darslarni olishda xatolik yuz berdi.',
        ),
      );
    }

    final decoded = decodeList(response.body);
    final lessons = decoded.map(Lesson.fromMap).toList()
      ..sort((a, b) {
        final byOrder = a.order.compareTo(b.order);
        if (byOrder != 0) return byOrder;
        return a.title.compareTo(b.title);
      });
    return lessons;
  }
}
