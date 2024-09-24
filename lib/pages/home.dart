import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const platform = MethodChannel('com.example.safe_surf/device_admin');

  @override
  void initState() {
    super.initState();
    _checkAndRequestAdminPrivileges();
  }

  Future<void> _checkAndRequestAdminPrivileges() async {
    try {
      bool isAdminActive = await platform.invokeMethod('isAdminActive');
      if (!isAdminActive) {
        await platform.invokeMethod('requestAdminPrivileges');
      }
    } on PlatformException {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Surf'),
      ),
      body: const Center(
        child: Text('Your app content goes here'),
      ),
    );
  }
}
