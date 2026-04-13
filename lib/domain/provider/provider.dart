import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceVerificationProvider with ChangeNotifier {
  bool _isVerified = false;

  bool get isVerified => _isVerified;

  Future<void> loadVerification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isVerified = prefs.getBool('isFaceVerified') ?? false;
    notifyListeners();
  }

  Future<void> setVerified(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFaceVerified', value);
    _isVerified = value;
    notifyListeners();
  }
}
