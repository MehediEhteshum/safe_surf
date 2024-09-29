import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIApiClient {
  final String baseUrl = 'https://api.openai.com/v1';
  final String apiKey;

  OpenAIApiClient({required this.apiKey});

  Future<Map<String, dynamic>> moderateContent(String content) async {
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
        'model': 'text-moderation-latest',
        // 'model': 'text-moderation-stable',
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to moderate content: ${response.statusCode}: ${response.body}');
    }
  }
}
