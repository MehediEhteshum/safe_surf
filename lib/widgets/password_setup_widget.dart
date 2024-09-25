import 'package:flutter/material.dart';

class PasswordSetupWidget extends StatelessWidget {
  final TextEditingController passwordController;
  final VoidCallback onSetPassword;

  const PasswordSetupWidget({
    super.key,
    required this.passwordController,
    required this.onSetPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Please set up a password (4+ characters):'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onSetPassword,
          child: const Text('Set Password'),
        ),
      ],
    );
  }
}
