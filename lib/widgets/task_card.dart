import 'package:intl/intl.dart';

import '../headers.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(
            '${task.description}\n${DateFormat.yMMMd().add_jm().format(task.scheduledAt)}'),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            Get.find<TaskController>().deleteTask(task.id);
          },
        ),
      ),
    );
  }
}
