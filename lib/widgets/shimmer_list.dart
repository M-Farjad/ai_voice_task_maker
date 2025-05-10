import '../headers.dart';
import 'shimmer_container.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key, this.onRefresh});

  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh ?? () async {},
      child: ListView.builder(
        itemBuilder: (context, index) => const ShimmerContainer(),
        itemCount: 6,
        padding: const EdgeInsets.all(4),
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
