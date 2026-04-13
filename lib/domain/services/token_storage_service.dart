import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  TokenStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage;

  Future<String?> readAccessToken() async {
    final token = await _storage.read(key: _accessTokenKey);
    if (token != null && token.isNotEmpty) {
      return token;
    }

    return _migrateLegacyToken(_accessTokenKey);
  }

  Future<String?> readRefreshToken() async {
    final token = await _storage.read(key: _refreshTokenKey);
    if (token != null && token.isNotEmpty) {
      return token;
    }

    return _migrateLegacyToken(_refreshTokenKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }

    await _clearLegacyToken(_accessTokenKey);
    await _clearLegacyToken(_refreshTokenKey);
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
    await _clearLegacyToken(_accessTokenKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _clearLegacyToken(_accessTokenKey);
    await _clearLegacyToken(_refreshTokenKey);
  }

  Future<String?> _migrateLegacyToken(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final legacyToken = prefs.getString(key);
    if (legacyToken == null || legacyToken.isEmpty) {
      return null;
    }

    await _storage.write(key: key, value: legacyToken);
    await prefs.remove(key);
    return legacyToken;
  }

  Future<void> _clearLegacyToken(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
