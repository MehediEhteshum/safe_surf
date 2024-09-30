import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OpenAIApiClient {
  final String baseUrl = 'https://api.openai.com/v1';
  final String apiKey;

  OpenAIApiClient({required this.apiKey});

  Future<bool> hasProfanity(String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/moderations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'input': content,
        // 'model': 'omni-moderation-latest',
        // 'model': 'omni-moderation-2024-09-26',
        // 'model': 'text-moderation-latest',
        'model': 'text-moderation-stable',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List)[0]['flagged'];
    } else {
      debugPrint(
          'Failed to check for profanity by OpenAI: ${response.statusCode}: ${response.body}');
      final mockData = await _mockOpenAIResponse();
      return (mockData['results'] as List)[0]['flagged'];
    }
  }

  Future<Map<String, dynamic>> _mockOpenAIResponse() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      "id": "modr-AB8CjOTu2jiq12hp1AQPfeqFWaORR",
      "model": "text-moderation-007",
      "results": [
        {
          "flagged": Random().nextBool(),
          "categories": {
            "sexual": false,
            "hate": false,
            "harassment": true,
            "self-harm": false,
            "sexual/minors": false,
            "hate/threatening": false,
            "violence/graphic": false,
            "self-harm/intent": false,
            "self-harm/instructions": false,
            "harassment/threatening": true,
            "violence": true
          },
          "category_scores": {
            "sexual": 0.000011726012417057063,
            "hate": 0.22706663608551025,
            "harassment": 0.5215635299682617,
            "self-harm": 2.227119921371923e-6,
            "sexual/minors": 7.107352217872176e-8,
            "hate/threatening": 0.023547329008579254,
            "violence/graphic": 0.00003391829886822961,
            "self-harm/intent": 1.646940972932498e-6,
            "self-harm/instructions": 1.1198755256458526e-9,
            "harassment/threatening": 0.5694745779037476,
            "violence": 0.9971134662628174
          }
        }
      ]
    };
  }
}

class ProfanityCleanerClient {
  final String baseUrl =
      'https://profanity-cleaner-bad-word-filter.p.rapidapi.com';
  final String apiKey;

  ProfanityCleanerClient({required this.apiKey});

  Future<bool> hasProfanity(String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/profanity'),
      headers: {
        'Content-Type': 'application/json',
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'profanity-cleaner-bad-word-filter.p.rapidapi.com',
      },
      body: jsonEncode({
        'text': content,
        "maskCharacter": "x",
        'language': 'en',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data["profanities"] as List).isNotEmpty;
    } else {
      debugPrint(
          'Failed to check for profanity by ProfanityCleaner: ${response.statusCode}: ${response.body}');
      final mockData = await _mockProfanityResponse();
      return (mockData["profanities"] as List).length * Random().nextInt(2) > 0;
    }
  }

  Future<Map<String, dynamic>> _mockProfanityResponse() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      "clean": "What is this xxxx.",
      "language": "en",
      "profanities": ["shit"]
    };
  }
}
