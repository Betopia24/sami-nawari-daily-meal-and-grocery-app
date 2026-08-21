import 'dart:async';
import 'package:get/get.dart';
import '../../../../../routes/app_routes.dart';

class SuccessController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    final nextRoute =
        Get.arguments != null && Get.arguments['nextRoute'] != null
        ? Get.arguments['nextRoute']
        : Routes.locationaccess;

    // Wait for 3 seconds then navigate
    Timer(const Duration(seconds: 3), () {
      Get.offAllNamed(nextRoute);
    });
  }
}
