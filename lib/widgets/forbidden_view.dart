import 'package:flutter/material.dart';

class ForbiddenView extends StatelessWidget {
  const ForbiddenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Access Forbidden',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'This content is not allowed.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
