import '../headers.dart';

class EmptyTaskListWidget extends StatelessWidget {
  const EmptyTaskListWidget({super.key, required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 164,
          child: Image.asset(Assets.emptyList),
        ),
        const SizedBox(height: 12),
        Text(
          'No $type Listed',
          textAlign: TextAlign.center,
          style: TxtStyles.regularWorkSans12(
            Colors.black,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
