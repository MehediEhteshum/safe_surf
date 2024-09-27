import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_surf/usecases/dns_blocker/start_dns_blocking.dart';
import 'package:safe_surf/utils/dependency_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const platform = MethodChannel('com.example.safe_surf/device_admin');
  String _blockingStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _checkAndRequestAdminPrivileges();
    _startDnsBlocking();
  }

  Future<void> _checkAndRequestAdminPrivileges() async {
    try {
      bool isAdminActive = await platform.invokeMethod('isAdminActive');
      if (!isAdminActive) {
        await platform.invokeMethod('requestAdminPrivileges');
      }
      debugPrint('Admin privileges checked and requested if necessary');
    } on PlatformException catch (e) {
      debugPrint("Failed to get admin status: '${e.message}'.");
      // Handle or log the error
    }
  }

  Future<void> _startDnsBlocking() async {
    final startDnsBlocking = getIt<StartDnsBlocking>();
    try {
      await startDnsBlocking();
      setState(() {
        _blockingStatus = 'DNS blocking active';
      });
    } catch (e) {
      debugPrint('Error starting DNS blocking: $e');
      setState(() {
        _blockingStatus = 'Failed to start DNS blocking';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Surf'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('YouTube Shorts Blocker Status:'),
            Text(_blockingStatus,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
