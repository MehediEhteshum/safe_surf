import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_surf/utils/password_manager.dart';
import 'package:safe_surf/widgets/password_setup_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const platform = MethodChannel('com.example.safe_surf/device_admin');
  final PasswordManager _passwordManager = PasswordManager();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordSet = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestAdminPrivileges();
    _checkPasswordStatus();
  }

  Future<void> _checkAndRequestAdminPrivileges() async {
    try {
      bool isAdminActive = await platform.invokeMethod('isAdminActive');
      if (!isAdminActive) {
        await platform.invokeMethod('requestAdminPrivileges');
      }
    } on PlatformException {
      // TO DO: Handle or log the error
    }
  }

  Future<void> _checkPasswordStatus() async {
    bool isSet = await _passwordManager.isPasswordSet();
    setState(() {
      _isPasswordSet = isSet;
    });
  }

  Future<void> _setPassword() async {
    if (_passwordController.text.length >= 4) {
      await _passwordManager.setPassword(_passwordController.text);
      setState(() {
        _isPasswordSet = true;
      });
      _passwordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password must be at least 4 characters long')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Surf'),
      ),
      body: Center(
        child: _isPasswordSet
            ? const Text('Your app content goes here')
            : PasswordSetupWidget(
                passwordController: _passwordController,
                onSetPassword: _setPassword,
              ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
