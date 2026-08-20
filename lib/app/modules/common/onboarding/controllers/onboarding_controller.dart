import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void previous() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void next() {
    if (currentIndex.value == 2) {
      Get.offAllNamed(
        '/home',
      ); // We'll implement home later, this will just crash or do nothing if route doesn't exist. Let's just use a print or a snackbar for now.
      Get.snackbar('Welcome', 'Going to home page');
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void skip() {
    Get.offAllNamed('/home');
    Get.snackbar('Welcome', 'Going to home page');
  }
}
