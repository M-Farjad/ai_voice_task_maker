import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../headers.dart';

class LLMService {
  static Future<Map<String, dynamic>> parseCommand(String speechText) async {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final defaultDatetime = DateFormat('yyyy-MM-dd HH:mm').format(tomorrow);

    final defaultTitle = "Task ${TaskLogic.taskCounter}";

    final prompt = '''
You are a smart assistant. Extract task data from the following user command. Respond ONLY with a valid JSON object. Do not include any text or explanation outside the JSON. The Current date and time is "$now".

Requirements:
- Look for the following fields: action (create, update, delete), title, description, datetime. Any date/time will be the date/time for the task.
- Extract fields: action (create, update, delete), title, description, datetime.
- If datetime is missing, set it to "$defaultDatetime" only when its in create mode.
- If title is missing, set it to "$defaultTitle" only when its in create mode.
- Ensure "datetime" is in format: "YYYY-MM-DD HH:mm".
- If action is not clear, set it to "create".
- If action is "delete", title should be the task title to delete.
- If action is "update", title should be the task title to update.
- If action is "update", then provide the datetime and description only when asked otherwise null.
- Make sure to update only the things that are asked in the command e.g. if asked to update the title, then only update the title and keep the rest as it is.

Input: "$speechText"

Output example:
{
  "action": "create",
  "title": "Buy groceries",
  "description": "Buy milk and bread",
  "datetime": "2025-12-05 20:50"
}
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
            {
              "role": "system",
              "content":
                  "You are a helpful assistant that only responds with clean JSON output."
            },
            {"role": "user", "content": prompt}
          ],
          "temperature": 0.2
        }),
      );

      final jsonResponse = jsonDecode(response.body);

      final rawText = jsonResponse["choices"][0]["message"]["content"].trim();

      // Clean up and ensure it's JSON
      final jsonStart = rawText.indexOf('{');
      final jsonEnd = rawText.lastIndexOf('}');
      if (jsonStart == -1 || jsonEnd == -1)
        throw const FormatException("No JSON found");

      final cleanJson = rawText.substring(jsonStart, jsonEnd + 1);
      return jsonDecode(cleanJson);
    } catch (e) {
      print('LLM parse error: $e');
      return {
        "action": null,
        "title": defaultTitle,
        "description": null,
        "datetime": defaultDatetime,
      };
    }
  }
}
