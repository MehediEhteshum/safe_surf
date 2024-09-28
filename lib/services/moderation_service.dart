import 'dart:math';
import 'package:flutter/foundation.dart';

class ModerationService {
  Future<bool> checkText(String text) async {
    // Simulate API call with a random result
    await Future.delayed(const Duration(milliseconds: 300));
    bool result = Random().nextBool();
    debugPrint('ModerationService: Checked text "$text", result: $result');
    return result;
  }
}
