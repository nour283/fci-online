import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';

class AuthProvider with ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> register({
    required String userName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.register(
        userName: userName,
        email: email,
        password: password,
      );

      isLoading = false;
      notifyListeners();

      final success = result['success'] == true;
      final message = result['message']?.toString() ?? "Success";

      if (success) {
        final token = result['token'];
        if (token != null) {
          await LocalStorageService.saveToken(token);
        }
        await LocalStorageService.saveUserName(userName);
        await LocalStorageService.saveEmail(email);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      return success;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );

      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.login(
        email: email,
        password: password,
      );

      isLoading = false;
      notifyListeners();

      final success = result['success'] == true;
      final message = result['message']?.toString() ?? "Login success";

      if (success) {
        final token = result['token'];
        final userName = result['user']?['userName'] ?? 'User';

        if (token != null) {
          await LocalStorageService.saveToken(token);
        }
        await LocalStorageService.saveUserName(userName);
        await LocalStorageService.saveEmail(email);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      return success;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );

      return false;
    }
  }
}
