import 'package:ai_voice_task_maker/widgets/empty_list.dart';
import 'package:lottie/lottie.dart';

import '../headers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    AuthService.authStateChanges.listen((user) async {
      if (user != null) {
        await Get.put(TaskController()).fetchTasks();
      }
    });
  }

  final speechService = SpeechService();

  @override
  Widget build(BuildContext context) {
    taskController.fetchTasks();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Voice Task Manager',
          style: TxtStyles.regularPoppins22(Colors.black,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: 'Logout',
                buttonColor: Colors.deepPurpleAccent,
                titleStyle: TxtStyles.regularPoppins22(Colors.black,
                    fontWeight: FontWeight.w600),
                middleTextStyle: TxtStyles.regularPoppins16(Colors.black),
                content: const Text('Are you sure you want to logout?'),
                onConfirm: () async {
                  await AuthService.signOut();
                  Get.offAllNamed(Pages.login);
                },
                onCancel: () => Get.back(),
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Obx(() {
          if (taskController.tasks.isEmpty) {
            return const EmptyTaskListWidget(type: 'Task');
          }
          return ListView.builder(
            itemCount: taskController.tasks.length,
            itemBuilder: (context, index) {
              final task = taskController.tasks[index];
              return TaskCard(task: task);
            },
          );
        }),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: Obx(() => FloatingActionButton(
            onPressed: () => taskController.handleSpeechCommand(),
            shape: const CircleBorder(),
            child: taskController.isRecording.value
                ? (Lottie.asset(
                    Assets.recording,
                    width: 50,
                    height: 50,
                  ))
                : const Icon(
                    Icons.mic,
                    color: Colors.white,
                  ),
          )),
    );
  }
}
