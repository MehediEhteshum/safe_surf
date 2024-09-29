import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_surf/utils/constants.dart';
import 'package:safe_surf/widgets/youtube_button.dart';

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
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            YoutubeButton(
              ytButtonLabel: 'Youtube: Shorts Blocked',
              ytRouteName: ytWebRoute,
              shortsBlockJS: ytShortsBlockedJS,
            ),
            SizedBox(
              height: 15,
            ),
            YoutubeButton(
              ytButtonLabel: 'Youtube: No Shorts',
              ytRouteName: ytWebRoute,
              shortsBlockJS: ytNoShortsJS,
            ),
          ],
        ),
      ),
    );
  }
}
