// lib/api/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "https://elearnbackend-production.up.railway.app";

  static Future<Map<String, dynamic>> register({
    required String userName,
    required String email,
    required String password,
    String role = "instructor",
  }) async {
    final url = Uri.parse("$baseUrl/api/auth/register");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "userName": userName,
        "email": email,
        "password": password,
        "role": role,
      },
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return data; // رجّع كل البيانات
    } else {
      throw Exception(data['message'] ?? "Registration failed");
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/auth/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "email": email,
        "password": password,
      },
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return data; // رجّع كل البيانات
    } else {
      throw Exception(data['message'] ?? "Login failed");
    }
  }
}
