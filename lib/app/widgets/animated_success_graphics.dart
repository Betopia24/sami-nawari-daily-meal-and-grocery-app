import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import '../../../core/utils/app_assets.dart';

class AnimatedSuccessGraphics extends StatefulWidget {
  final double size;

  const AnimatedSuccessGraphics({super.key, this.size = 200});

  @override
  State<AnimatedSuccessGraphics> createState() =>
      _AnimatedSuccessGraphicsState();
}

class _AnimatedSuccessGraphicsState extends State<AnimatedSuccessGraphics>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _rotateAnimation = Tween<double>(begin: -math.pi, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: _rotateAnimation.value,
                child: SvgPicture.asset(
                  AppAssets.successArrows,
                  width: widget.size,
                  height: widget.size,
                ),
              ),
              Transform.scale(
                scale: _scaleAnimation.value,
                child: SvgPicture.asset(
                  AppAssets.successTick,
                  width: widget.size,
                  height: widget.size,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
