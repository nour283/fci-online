import 'package:flutter/material.dart';
import 'package:tadrib_hub/api/services/local_storage_service.dart';

class UserInfoProvider with ChangeNotifier {
  String _userName = '';
  String _userEmail = '';

  String get userName => _userName;
  String get userEmail => _userEmail;

  Future<void> loadUserInfo() async {
    _userName = await LocalStorageService.getUserName() ?? '';
    _userEmail = await LocalStorageService.getEmail() ?? '';
    notifyListeners();
  }

  Future<void> clearUserInfo() async {
    await LocalStorageService.clearAll();
    _userName = '';
    _userEmail = '';
    notifyListeners();
  }
}
