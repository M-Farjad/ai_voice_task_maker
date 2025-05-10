import 'package:intl/intl.dart';

import '../headers.dart';

class TaskLogic {
  static int taskCounter = 1; // Incremental counter for task IDs

  static TaskModel fromLLMResponse(Map<String, dynamic> data) {
    final now = DateTime.now();

    String title = data['title'] ?? "Task $taskCounter";
    DateTime? scheduledAt;
    String? description;
    if (data['action'] == "update") {
      data['description'] == null || data['description'] == "null"
          ? null
          : description = data['description'];
      data['datetime'] == null || data['datetime'] == "null"
          ? null
          : scheduledAt =
              DateFormat("yyyy-MM-dd HH:mm").parse(data['datetime']);
    } else {
      try {
        scheduledAt = DateFormat("yyyy-MM-dd HH:mm").parse(data['datetime']);
      } catch (_) {
        scheduledAt = now.add(const Duration(days: 1));
      }
    }

    final id = "task_${taskCounter++}"; // Generate simple numeric ID

    return TaskModel(
      id: id,
      title: title,
      description: description,
      scheduledAt: scheduledAt,
    );
  }
}
