import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/utils/app_assets.dart';

class CustomRecipeCover extends StatelessWidget {
  final double height;
  final double width;

  const CustomRecipeCover({
    super.key,
    required this.height,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: const Color(0xFFEBE6E0),
      child: Center(
        child: Transform.scale(
          scale: 1.8, // This overrides the padding inside the SVG file itself
          child: SvgPicture.asset(
            AppAssets.logoSvg,
            width: height,
            height: height,
            colorFilter: const ColorFilter.mode(
              Color(0xFF8B8378),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
