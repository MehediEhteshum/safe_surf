import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_surf/utils/constants.dart';

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
    } on PlatformException catch (e) {
      debugPrint("Failed to get admin status: '${e.message}'.");
      // Handle or log the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Surf'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('YouTube'),
            leading: const Icon(Icons.ondemand_video),
            onTap: () {
              Navigator.pushNamed(context, ytWebRoute);
            },
          ),
        ],
      ),
    );
  }
}
