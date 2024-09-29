import 'package:flutter/material.dart';
import 'package:safe_surf/pages/home.dart';
import 'package:safe_surf/utils/dependency_container.dart';
import 'package:safe_surf/utils/routes.dart';

Future<void> main() async {
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Surf',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
