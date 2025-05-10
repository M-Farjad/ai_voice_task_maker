import '../headers.dart';

class TaskController extends GetxController {
  final isRecording = false.obs;
  final isLoading = false.obs;
  final tasks = <TaskModel>[].obs;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  dispose() {
    super.dispose();
    stopRecording();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      final snapshot = await firestoreInstance
          .collection('tasks')
          .orderBy('scheduledAt')
          .get();
      tasks.value =
          snapshot.docs.map((e) => TaskModel.fromJson(e.data())).toList();
    } catch (e) {
      print('Error fetching tasks: $e');
    }
    isLoading.value = false;
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await firestoreInstance
          .collection('tasks')
          .doc(task.id)
          .set(task.toJson());
      await fetchTasks();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await firestoreInstance
          .collection('tasks')
          .doc(task.id)
          .update(task.toJson());
      await fetchTasks();
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await firestoreInstance.collection('tasks').doc(id).delete();
      await fetchTasks();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  void handleSpeechCommand() async {
    isRecording.value = true;
    final speech = await SpeechService.listen();
    isRecording.value = false;
    if (speech == null) return;

    final parsed = await LLMService.parseCommand(speech);
    final action = parsed['action'];

    if (action == 'create') {
      final task = TaskLogic.fromLLMResponse(parsed);
      await addTask(task);
    } else if (action == 'update') {
      final task = TaskLogic.fromLLMResponse(parsed);
      await updateTask(
          task); // You’d find and update existing task by title or ID
    } else if (action == 'delete') {
      final title = parsed['title'];
      final existing = tasks.firstWhereOrNull((e) => e.title == title);
      if (existing != null) {
        await deleteTask(existing.id);
      }
    }
  }

  void stopRecording() async {
    isRecording.value = false;
    await SpeechService.stop();
  }
}
