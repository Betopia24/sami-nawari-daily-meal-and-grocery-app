import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class RateappController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> star1Animation;
  late Animation<double> star2Animation;
  late Animation<double> star3Animation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    star1Animation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    star2Animation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    );
    star3Animation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    );

    // Start animation after a tiny delay so it's visible when navigating
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!isClosed) {
        animationController.forward();
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
