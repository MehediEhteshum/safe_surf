import 'package:flutter/material.dart';

abstract class IDnsBlockerRepo extends ChangeNotifier {
  Future<int> startDnsProxy();
  Future<void> stopDnsProxy();
  bool get isBlocking;
}
