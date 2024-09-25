import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

class PasswordManager {
  static const String _passwordKey = 'app_password';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const platform = MethodChannel('com.example.safe_surf/password');

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

  void setupMethodChannel() {
    platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'isPasswordSet':
          return await isPasswordSet();
        case 'verifyPassword':
          final password = call.arguments as String;
          return await verifyPassword(password);
        default:
          throw PlatformException(
            code: 'NotImplemented',
            message: 'Method ${call.method} not implemented',
          );
      }
    });
  }
}
