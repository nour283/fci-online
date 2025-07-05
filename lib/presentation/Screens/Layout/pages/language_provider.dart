import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadrib_hub/generated/S.dart';

class LanguageProvider with ChangeNotifier {
  bool _isArabic = false;

  bool get isArabic => _isArabic;

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _isArabic = prefs.getBool('isArabic') ?? false;
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _isArabic = !_isArabic;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isArabic', _isArabic);

    
    S.setLocale(Locale(_isArabic ? 'ar' : 'en'));

    notifyListeners(); 
  }
}