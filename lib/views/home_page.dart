import 'package:ai_voice_task_maker/widgets/empty_list.dart';
import 'package:lottie/lottie.dart';

import '../headers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(TaskController());

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
    controller.fetchTasks();

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
            onPressed: showLogOutDialog,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Obx(() {
          return RefreshIndicator.adaptive(
            onRefresh: () async => controller.fetchTasks(),
            child: controller.isLoading.value
                ? ShimmerList(onRefresh: controller.fetchTasks)
                : getShiftTypeView(),
          );
        }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
              side: const BorderSide(color: Colors.black, width: 1),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 6, bottom: 6, top: 6, right: 6),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Text(
                          'Loading...',
                          style: TxtStyles.regularPoppins16(Colors.black,
                              fontWeight: FontWeight.w600),
                        );
                      } else if (controller.isRecording.value) {
                        return Text(
                          'Listening...',
                          style: TxtStyles.regularPoppins16(Colors.black,
                              fontWeight: FontWeight.w600),
                        );
                      }
                      return Text(
                        'Press the mic to start recording',
                        style: TxtStyles.regularPoppins16(Colors.black,
                            fontWeight: FontWeight.w600),
                      );
                    }),
                    FloatingActionButton(
                      onPressed: controller.isRecording.value
                          ? () => controller.stopRecording()
                          : () => controller.startListening(),
                      shape: const CircleBorder(),
                      child: controller.isRecording.value
                          ? Lottie.asset(Assets.recording)
                          : const Icon(
                              Icons.mic,
                              color: Colors.white,
                            ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void showLogOutDialog() {
    Get.defaultDialog(
      title: 'Logout',
      buttonColor: Colors.deepPurpleAccent,
      titleStyle:
          TxtStyles.regularPoppins22(Colors.black, fontWeight: FontWeight.w600),
      middleTextStyle: TxtStyles.regularPoppins16(Colors.black),
      content: const Text('Are you sure you want to logout?'),
      onConfirm: () async {
        await AuthService.signOut();
        Get.offAllNamed(Pages.login);
      },
      onCancel: () => Get.back(),
    );
  }

  Widget getShiftTypeView() {
    if (controller.tasks.isEmpty) {
      return const EmptyTaskListWidget(type: 'Task');
    }
    final now = DateTime.now();
    final upcomingTasks = controller.tasks
        .where((task) => task.scheduledAt!.isAfter(now))
        .toList();
    final oldTasks = controller.tasks
        .where((task) => task.scheduledAt!.isBefore(now))
        .toList();

    return ListView(
      children: [
        if (upcomingTasks.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Upcoming Tasks',
              style: TxtStyles.regularPoppins16(Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          ...upcomingTasks.map((task) => TaskCard(task: task)),
        ],
        if (oldTasks.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Old Tasks',
              style: TxtStyles.regularPoppins16(Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          ...oldTasks.map((task) => TaskCard(task: task)),
        ],
      ],
    );
  }
}
