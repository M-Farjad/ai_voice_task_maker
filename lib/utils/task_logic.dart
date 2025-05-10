import 'package:intl/intl.dart';

import '../headers.dart';

class TaskLogic {
  static TaskModel fromLLMResponse(Map<String, dynamic> data) {
    final now = DateTime.now();
    final uuid = const Uuid().v4();

    String title = data['title'] ?? "Untitled Task $uuid";
    String description = data['description'] ?? "No description provided.";
    DateTime scheduledAt;

    try {
      scheduledAt = DateFormat("yyyy-MM-dd HH:mm").parse(data['datetime']);
    } catch (_) {
      scheduledAt = now.add(const Duration(days: 1));
    }

    return TaskModel(
      id: uuid,
      title: title,
      description: description,
      scheduledAt: scheduledAt,
    );
  }
}
