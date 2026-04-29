import 'package:flutter/material.dart';
import 'package:pr/features/auth/domain/usecases/exchange_code.dart';
import 'package:pr/features/auth/domain/usecases/get_authorization_url.dart';

class AuthProvider extends ChangeNotifier {
  final GetAuthorizationUrl _getAuthorizationUrl;
  final ExchangeCode _exchangeCode;

  AuthProvider(this._getAuthorizationUrl, this._exchangeCode);

  bool isLoadingUrl = false;
  bool isSubmittingCode = false;
  String? errorMessage;
  String? infoMessage;
  bool isAuthenticated = false;

  Future<String?> fetchAuthorizationUrl() async {
    isLoadingUrl = true;
    errorMessage = null;
    infoMessage = null;
    notifyListeners();
    try {
      final url = await _getAuthorizationUrl();
      infoMessage = 'Havola tayyor. Kirish oynasi ochilmoqda...';
      notifyListeners();
      return url;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    } finally {
      isLoadingUrl = false;
      notifyListeners();
    }
  }

  Future<bool> submitCode(String code) async {
    isSubmittingCode = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _exchangeCode(code);
      isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      isSubmittingCode = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    errorMessage = null;
    infoMessage = null;
    notifyListeners();
  }
}
