import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable Shimmer placeholder widget following clean UI guidelines
class CustomShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final ShapeBorder shapeBorder;
  final BorderRadiusGeometry? borderRadius;

  const CustomShimmer.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    BorderRadius? borderRadius,
  })  : shapeBorder = const RoundedRectangleBorder(),
        borderRadius = borderRadius ?? const BorderRadius.all(Radius.circular(8));

  const CustomShimmer.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        shapeBorder = const CircleBorder(),
        borderRadius = null;

  CustomShimmer.card({
    super.key,
    this.width,
    this.height,
    double radius = 16,
  })  : shapeBorder = const RoundedRectangleBorder(),
        borderRadius = BorderRadius.all(Radius.circular(radius));

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB), // Light gray base
      highlightColor: const Color(0xFFF9FAFB), // Soft off-white shine
      period: const Duration(milliseconds: 1400),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          shape: shapeBorder is CircleBorder ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}
