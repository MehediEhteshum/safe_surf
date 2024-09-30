import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safe_surf/data/api_client.dart';

class ModerationService {
  final ProfanityCleanerClient _apiClient;

  ModerationService()
      : _apiClient =
            ProfanityCleanerClient(apiKey: dotenv.env['PCLEANER_API_KEY']!);

  Future<bool> isAppropriateText(String text) async {
    return !(await _apiClient.hasProfanity(text));
  }
}
