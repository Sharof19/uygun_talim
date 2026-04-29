import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pr/core/constants/api_constants.dart';
import 'package:pr/core/errors/exceptions.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Map<String, String> _headers(String token) => {
    'accept': 'application/json',
    'Authorization': 'Bearer $token',
    'X-CSRFTOKEN': ApiConstants.csrfToken,
  };

  Map<String, String> _headersNoAuth() => {
    'accept': 'application/json',
    'X-CSRFTOKEN': ApiConstants.csrfToken,
  };

  // ------------------------------------------------------------------ GET list
  Future<List<Map<String, dynamic>>> getList(
    String url, {
    required String token,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    final response = await _client.get(uri, headers: _headers(token));
    _assertSuccess(response);
    return _decodeList(response.body);
  }

  // ------------------------------------------------------------------ GET map
  Future<Map<String, dynamic>> getMap(
    String url, {
    required String token,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    final response = await _client.get(uri, headers: _headers(token));
    _assertSuccess(response);
    return _decodeMap(response.body);
  }

  // ------------------------------------------------------------ GET map no auth
  Future<Map<String, dynamic>> getMapNoAuth(String url) async {
    final uri = Uri.parse(url);
    final response = await _client.get(uri, headers: _headersNoAuth());
    _assertSuccess(response);
    return _decodeMap(response.body);
  }

  // ----------------------------------------------------------------- POST map
  Future<Map<String, dynamic>> post(
    String url, {
    required String token,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse(url);
    final response = await _client.post(
      uri,
      headers: {..._headers(token), 'Content-Type': 'application/json'},
      body: jsonEncode(body ?? {}),
    );
    _assertSuccess(response);
    return _decodeMap(response.body);
  }

  // --------------------------------------------------- GET with fallback urls
  Future<Map<String, dynamic>> getMapWithFallback(
    List<String> urls, {
    String token = '',
  }) async {
    http.Response? last;
    for (final url in urls) {
      final uri = Uri.parse(url);
      final headers = token.isNotEmpty ? _headers(token) : _headersNoAuth();
      final response = await _client.get(uri, headers: headers);
      last = response;
      if (response.statusCode != 404) break;
    }
    if (last == null) throw const ServerException('No response received.');
    _assertSuccess(last);
    return _decodeMap(last.body);
  }

  // ----------------------------------------------------------------- helpers
  void _assertSuccess(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) return;
    throw ServerException(_extractError(response.body));
  }

  String _extractError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        for (final key in ['message', 'detail', 'error_description', 'error']) {
          final val = decoded[key] as String?;
          if (val != null && val.isNotEmpty) return val;
        }
        final nonField = decoded['non_field_errors'];
        if (nonField is List && nonField.isNotEmpty) {
          return nonField.first.toString();
        }
      }
    } catch (_) {}
    return 'Xatolik yuz berdi.';
  }

  List<Map<String, dynamic>> _decodeList(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is List) {
        return decoded.whereType<Map<String, dynamic>>().toList();
      }
      if (decoded is Map<String, dynamic>) {
        final results = decoded['results'] ?? decoded['data'];
        if (results is List) {
          return results.whereType<Map<String, dynamic>>().toList();
        }
      }
    } catch (_) {}
    return [];
  }

  Map<String, dynamic> _decodeMap(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final data = decoded['data'];
        if (data is Map<String, dynamic> && data.isNotEmpty) return data;
        return decoded;
      }
    } catch (_) {}
    return {};
  }
}
