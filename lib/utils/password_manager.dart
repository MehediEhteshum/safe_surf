import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordManager {
  static const platform = MethodChannel('com.example.safe_surf/device_admin');

  Future<void> setPassword(String password) async {
    try {
      await platform.invokeMethod('setPassword', {'password': password});
    } on PlatformException catch (e) {
      debugPrint("Failed to set password: '${e.message}'.");
    }
  }

  Future<bool> isPasswordSet() async {
    try {
      return await platform.invokeMethod('isPasswordSet');
    } on PlatformException catch (e) {
      debugPrint("Failed to check if password is set: '${e.message}'.");
      return false;
    }
  }
}
