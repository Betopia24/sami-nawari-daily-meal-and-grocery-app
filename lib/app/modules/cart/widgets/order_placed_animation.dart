import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/app_assets.dart';

class OrderPlacedAnimation extends StatefulWidget {
  const OrderPlacedAnimation({super.key});

  @override
  State<OrderPlacedAnimation> createState() => _OrderPlacedAnimationState();
}

class _OrderPlacedAnimationState extends State<OrderPlacedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _bgScaleAnimation;
  late Animation<double> _bagScaleAnimation;
  late Animation<double> _shadowOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Background pops in
    _bgScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Bag group pops in slightly after
    _bagScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      ),
    );

    // Shadow fades in
    _shadowOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
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
    // Precise mathematical alignment:
    // Green circle diameter is 112.5. Center is at (56.25, 56.25).
    // The bag and shadow share the exact same top-left origin.
    // Placing them at left: 26.25, top: 23.0 perfectly centers the bag (60x67)
    // inside the circle (26.25 + 30 = 56.25), and perfectly aligns the shadow's
    // 56.25 radius pre-clipped arc with the green circle's edge.
    const double exactLeft = 26.25;
    const double exactTop = 23.0;

    return SizedBox(
      width: 113,
      height: 113,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // 1. Background (Green Circle)
              Center(
                child: Transform.scale(
                  scale: _bgScaleAnimation.value,
                  child: SvgPicture.asset(
                    AppAssets.orderPlacedBg,
                    width: 113,
                    height: 113,
                  ),
                ),
              ),
              
              // 2. Bag and Shadow Group
              Positioned(
                left: exactLeft,
                top: exactTop,
                child: Transform.scale(
                  scale: _bagScaleAnimation.value,
                  // Scale from the exact center of the bag (30, 33.5) relative to the 83x90 shadow bounding box.
                  // This ensures the animation pops out directly from the center of the green circle!
                  alignment: const FractionalOffset(30.0 / 83.0, 33.5 / 90.0),
                  child: SizedBox(
                    width: 83, // Size of the shadow (largest element)
                    height: 90,
                    child: Stack(
                      children: [
                        // Shadow
                        Opacity(
                          opacity: _shadowOpacityAnimation.value,
                          child: SvgPicture.asset(
                            AppAssets.orderPlacedShadow,
                            width: 83,
                            height: 90,
                          ),
                        ),
                        // Bag
                        SvgPicture.asset(
                          AppAssets.orderPlacedBag,
                          width: 60,
                          height: 67,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

