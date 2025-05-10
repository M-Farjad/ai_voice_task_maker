import 'package:intl/intl.dart';

import '../headers.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final TaskController controller = Get.find<TaskController>();

  TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            height: 50,
            width: 50,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.red,
            ),
            child: const Icon(Icons.delete, color: CustomColors.white),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      key: ValueKey(task.id),
      onDismissed: (direction) {
        controller.deleteTask(task.title!);
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: ListTile(
          onTap: () => controller.showTaskDetailsDialog(task),
          title: Text(task.title ?? "No title",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TxtStyles.regularPoppins16(
                  const Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          leading: Image.asset(
            task.scheduledAt!.isBefore(DateTime.now())
                ? Assets.notDone
                : Assets.done,
          ),
          subtitle: Text(task.description ?? "No description",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TxtStyles.regularPoppins14(Colors.black,
                  fontWeight: FontWeight.w400)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('dd/MM/yy').format(task.scheduledAt!),
                style: TxtStyles.regularPoppins12(Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                DateFormat('hh:mm a').format(task.scheduledAt!),
                style: TxtStyles.regularPoppins12(Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
