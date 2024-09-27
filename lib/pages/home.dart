import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:safe_surf/repos/dns_blocker/i_dns_blocker_repo.dart';
import 'package:safe_surf/utils/dependency_container.dart';
import 'package:safe_surf/widgets/dns_blocker/dns_blocker_toggle.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IDnsBlockerRepo>(
          create: (_) => getIt<IDnsBlockerRepo>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Safe Surf'),
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: const [
              Text('Block YouTube Shorts'),
              DnsBlockerToggle(),
            ],
          ),
        ),
      ),
    );
  }
}
