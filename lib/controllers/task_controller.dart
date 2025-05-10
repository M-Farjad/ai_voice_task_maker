import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:string_similarity/string_similarity.dart';
import '../headers.dart';

class TaskController extends GetxController {
  final isRecording = false.obs;
  final isLoading = false.obs;
  final tasks = <TaskModel>[].obs;
  final firestoreInstance = FirebaseFirestore.instance;

  String get _uid => AuthService.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    if (_uid.isNotEmpty) fetchTasks();
  }

  @override
  void dispose() {
    stopRecording();
    super.dispose();
  }

  Future<void> fetchTasks() async {
    if (_uid.isEmpty) return;
    try {
      isLoading.value = true;
      final snapshot = await firestoreInstance
          .collection('users')
          .doc(_uid)
          .collection('tasks')
          .orderBy('scheduledAt')
          .get();
      tasks.value =
          snapshot.docs.map((e) => TaskModel.fromJson(e.data())).toList();
    } catch (e) {
      log('Error fetching tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask(TaskModel task) async {
    if (_uid.isEmpty) return;
    try {
      isLoading.value = true;
      final existingTaskSnapshot = await firestoreInstance
          .collection('users')
          .doc(_uid)
          .collection('tasks')
          .where('title', isEqualTo: task.title)
          .limit(1)
          .get();

      if (existingTaskSnapshot.docs.isNotEmpty) {
        log('A task with the title "${task.title}" already exists.');
        Get.snackbar("Already in List",
            "A task with the title '${task.title}' already exists.");
        return;
      }

      await firestoreInstance
          .collection('users')
          .doc(_uid)
          .collection('tasks')
          .doc(task.id)
          .set(task.toJson());
      await fetchTasks();
    } catch (e) {
      log('Error adding task: $e');
    }
    isLoading.value = false;
  }

  Future<void> updateTask(TaskModel task) async {
    if (_uid.isEmpty) return;
    try {
      isLoading.value = true;
      final closest = _findClosestTask(task.title);
      if (closest != null) {
        final docRef = firestoreInstance
            .collection('users')
            .doc(_uid)
            .collection('tasks')
            .where('title', isEqualTo: closest.title)
            .limit(1);

        final snapshot = await docRef.get();
        if (snapshot.docs.isNotEmpty) {
          final existingData = snapshot.docs.first.data();
          final updatedData = task.toJson()
            ..removeWhere((key, value) => value == null);

          final mergedData = existingData.map((key, value) {
            return updatedData.containsKey(key)
                ? MapEntry(key, updatedData[key])
                : MapEntry(key, value);
          });

          await snapshot.docs.first.reference.update(mergedData);
        }
        await fetchTasks();
      } else {
        log("No similar task found for '${task.title}' to update.");
      }
    } catch (e) {
      log('Error updating task: $e');
      if (e.toString() ==
          "[cloud_firestore/not-found] Some requested document was not found.") {
        Get.snackbar("Update Failed", "Task not found.");
      }
    }
    isLoading.value = false;
  }

  Future<void> deleteTask(String spokenTitle) async {
    if (_uid.isEmpty) {
      log('User ID is empty. Cannot delete task.');
      return;
    }
    try {
      final closest = _findClosestTask(spokenTitle);
      if (closest == null) {
        log("No similar task found for '$spokenTitle' to delete.");
        return;
      }
      final snapshot = await firestoreInstance
          .collection('users')
          .doc(_uid)
          .collection('tasks')
          .where('title', isEqualTo: closest.title)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
        tasks.removeWhere((task) => task.title == closest.title);
      }
      log("Deleted task with title: ${closest.title}");
    } catch (e) {
      log('Error deleting task: $e');
    }
  }

  Future<void> directDeleteTask(TaskModel task) async {
    if (_uid.isEmpty) {
      log('User ID is empty. Cannot delete task.');
      return;
    }
    try {
      await firestoreInstance
          .collection('users')
          .doc(_uid)
          .collection('tasks')
          .doc(task.id)
          .delete();
      // await fetchTasks();
    } catch (e) {
      log('Error deleting task: $e');
    }
  }

  void startListening() async {
    isRecording.value = true;
    await SpeechService.listen();
  }

  Future<void> callLLMForResponse(String speech) async {
    try {
      final parsed = await LLMService.parseCommand(speech);
      final action = parsed['action'];
      log("Parsed Text: $parsed");

      if (action == 'create') {
        final task = TaskLogic.fromLLMResponse(parsed);
        await addTask(task);
      } else if (action == 'update') {
        final task = TaskLogic.fromLLMResponse(parsed);
        await updateTask(task);
      } else if (action == 'delete') {
        final title = parsed['title'];
        log("Deleting task with title: $title");
        await deleteTask(title ?? '');
      }
    } catch (e) {
      log('Error calling LLM: $e');
    }
  }

  TaskModel? _findClosestTask(String? title) {
    if (title == null || tasks.isEmpty) return null;
    final matches = tasks.map((task) {
      final similarity = StringSimilarity.compareTwoStrings(
        task.title?.toLowerCase(),
        title.toLowerCase(),
      );
      return {'task': task, 'score': similarity};
    }).toList();

    matches
        .sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));
    final bestMatch = matches.first;

    return (bestMatch['score'] as double) > 0.5
        ? bestMatch['task'] as TaskModel
        : null;
  }

  void stopRecording() async {
    final speech = await SpeechService.stop();
    if (speech == null || speech.isEmpty) {
      log('No speech detected');
      isRecording.value = false;
      return;
    }
    log("Speech Text: $speech");
    isRecording.value = false;
    await callLLMForResponse(speech);
    isRecording.value = false;
  }

  void showTaskDetailsDialog(TaskModel task) {
    Get.defaultDialog(
      title: task.title ?? "No title",
      content: Column(
        children: [
          Text(
            'Description: ${task.description}',
            style: TxtStyles.regularPoppins16(Colors.black),
          ),
          Text(
            'Scheduled At: ${DateFormat.yMMMd().format(task.scheduledAt!)}',
            style: TxtStyles.regularPoppins16(Colors.black),
          ),
        ],
      ),
      titleStyle:
          TxtStyles.regularPoppins22(Colors.black, fontWeight: FontWeight.w600),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text('OK'),
      ),
    );
  }
}
