import 'package:http/http.dart' as http;
import 'package:pr/domain/services/api_parsing.dart';

class Category {
  Category({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
  });

  final String id;
  final String title;
  final String slug;
  final String description;

  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      id: (data['id'] ?? '').toString(),
      title: (data['title'] ?? data['name'] ?? '').toString(),
      slug: (data['slug'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
    );
  }
}

class CategoryService with ApiParsing {
  CategoryService({
    http.Client? client,
    this.baseUrl = 'https://api.uyguntalim.tsue.uz/api',
    this.csrfToken = 'x9Jv5GBLMZLVyTRu6rFmF2b8uORvppSDOHtWzbixuyB9RmgznaYKyNpuBDv3eOSb',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final String csrfToken;

  Future<List<Category>> fetchCategories(String accessToken) async {
    final uri = Uri.parse('$baseUrl/categories/');
    final response = await _client.get(
      uri,
      headers: _headers(accessToken),
    );

    if (response.statusCode != 200) {
      throw Exception(
        extractErrorMessage(
          response.body,
          fallback: 'Kategoriyalarni olishda xatolik yuz berdi.',
        ),
      );
    }

    final decoded = decodeList(response.body);
    return decoded.map(Category.fromMap).toList();
  }

  Future<Map<String, dynamic>> fetchCategory(
    String accessToken,
    String id,
  ) async {
    final uri = Uri.parse('$baseUrl/categories/$id/');
    final response = await _client.get(
      uri,
      headers: _headers(accessToken),
    );

    if (response.statusCode != 200) {
      throw Exception(
        extractErrorMessage(
          response.body,
          fallback: 'Kategoriya maʼlumotlarini olishda xatolik yuz berdi.',
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
