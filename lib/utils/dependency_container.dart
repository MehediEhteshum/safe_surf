import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initializeDependencies() async {
  // dotenv load
  await dotenv.load(fileName: '.env');
}
