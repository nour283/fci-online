import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _username = '';
  String _email = '';

  // دوال لقراءة البيانات
  String get username => _username;
  String get email => _email;

  // دالة تعيين أو تحديث البيانات مع إشعار المستمعين
  void setUser({required String username, required String email}) {
    _username = username;
    _email = email;
    notifyListeners();
  }
}
