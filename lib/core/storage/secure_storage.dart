import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Abstract interface — lets you swap implementation or mock in tests
abstract class SecureStorage {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> saveTokens({required String accessToken, String? refreshToken});
  Future<void> clearTokens();
}

class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readAccessToken() async {
    final token = await _storage.read(key: _accessKey);
    if (token != null && token.isNotEmpty) return token;
    return _migrateLegacy(_accessKey);
  }

  @override
  Future<String?> readRefreshToken() async {
    final token = await _storage.read(key: _refreshKey);
    if (token != null && token.isNotEmpty) return token;
    return _migrateLegacy(_refreshKey);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(key: _refreshKey, value: refreshToken);
    }
    await _clearLegacy(_accessKey);
    await _clearLegacy(_refreshKey);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
    await _clearLegacy(_accessKey);
    await _clearLegacy(_refreshKey);
  }

  Future<String?> _migrateLegacy(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getString(key);
    if (legacy == null || legacy.isEmpty) return null;
    await _storage.write(key: key, value: legacy);
    await prefs.remove(key);
    return legacy;
  }

  Future<void> _clearLegacy(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
