import '../headers.dart';
import 'shimmer_widget.dart';

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        height: 113,
        width: 327,
        decoration: ShapeDecoration(
          color: Colors.grey[100],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        child: const Center(
          child: ShimmerListTile(),
        ),
      ),
    );
  }
}

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key, this.isTrailing});
  final bool? isTrailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      leading: const ShimmerWidget.circular(
        width: (50),
        height: (50),
      ),
      title: const ShimmerWidget.rectangular(height: (20)),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      subtitle: const Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ShimmerWidget.rectangular(
          height: (20),
          // width: isTrailing == true
          //     ? (10)
          //     : double.infinity,
        ),
      ),
      trailing: isTrailing == true
          ? const ShimmerWidget.rectangular(width: 56, height: 28)
          : null,
    );
  }
}
