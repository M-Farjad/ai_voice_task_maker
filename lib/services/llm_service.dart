import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LLMService {
  static Future<Map<String, dynamic>> parseCommand(String speechText) async {
    final prompt = '''
You are a smart assistant. Extract task data from user speech. Only respond with JSON.
The user will say something like "Create a task to buy groceries tomorrow at 5 PM". Your job is to extract the action (create, update, delete), title, description, and datetime from the speech text.
Input: "$speechText"
Output JSON format:
{
  "action": "create" | "update" | "delete",
  "title": "...",
  "description": "...",
  "datetime": "YYYY-MM-DD HH:mm"
}
If a field is missing, leave it as null.
''';

    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4",
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "temperature": 0.3
        }),
      );

      final json = jsonDecode(response.body);
      final text = json["choices"][0]["message"]["content"];

      return jsonDecode(text); // Parsed JSON as Map
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }
}
