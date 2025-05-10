import 'package:shimmer/shimmer.dart';

import '../headers.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
    this.child = const SizedBox.shrink(),
  });

  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    this.child = const SizedBox.shrink(),
  });

  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CustomColors.primaryColor.withOpacity(.15),
      highlightColor: CustomColors.grey.withOpacity(.05),
      child: Container(
        width: (width),
        height: (height),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: shapeBorder,
          shadows: const [
            BoxShadow(
              color: Color(0x07000000),
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: -20,
            )
          ],
        ),
      ),
    );
  }
}
