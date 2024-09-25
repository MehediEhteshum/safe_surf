// lib/utils/password_manager.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordManager {
  static const String _passwordKey = 'app_password';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> setPassword(String password) async {
    await _secureStorage.write(key: _passwordKey, value: password);
  }

  Future<String?> getPassword() async {
    return await _secureStorage.read(key: _passwordKey);
  }

  Future<bool> isPasswordSet() async {
    String? password = await getPassword();
    return password != null && password.isNotEmpty;
  }

  Future<bool> verifyPassword(String inputPassword) async {
    String? storedPassword = await getPassword();
    return storedPassword == inputPassword;
  }
}
