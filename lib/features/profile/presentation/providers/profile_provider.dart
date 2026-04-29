import 'package:flutter/material.dart';
import 'package:pr/features/profile/domain/entities/profile.dart';
import 'package:pr/features/profile/domain/usecases/get_profile.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfile _getProfile;
  ProfileProvider(this._getProfile);
  bool isLoading = false;
  String? errorMessage;
  Profile? profile;
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      profile = await _getProfile();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
