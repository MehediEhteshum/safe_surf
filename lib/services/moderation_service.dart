import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safe_surf/data/open_api_client.dart';

class ModerationService {
  final OpenAIApiClient _apiClient;

  ModerationService()
      : _apiClient = OpenAIApiClient(apiKey: dotenv.env['OPENAI_API_KEY']!);

  Future<bool> isAppropriateText(String text) async {
    try {
      final response = await _apiClient.moderateContent(text);
      final results = response['results'][0];
      bool isFlagged = results['flagged'];
      // Map<String, dynamic> categoryScores = results['category_scores'];
      debugPrint(
          'ModerationService: Checked text "$text", result from NLP: $isFlagged');
      return !isFlagged;
    } catch (e) {
      debugPrint('Error in moderation service: $e');
      // Simulate API call with a random result
      await Future.delayed(const Duration(milliseconds: 300));
      bool result = Random().nextBool();
      debugPrint('ModerationService: Checked text "$text", result: $result');
      return result;
      // In case of an error, assume the text is appropriate
      // to avoid blocking legitimate searches
      // return true;
    }
  }
}
