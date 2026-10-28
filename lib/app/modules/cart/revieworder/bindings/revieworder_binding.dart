import 'package:get/get.dart';
import '../controllers/revieworder_controller.dart';

class RevieworderBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<RevieworderController>()) {
      Get.delete<RevieworderController>(force: true);
    }
    Get.lazyPut<RevieworderController>(
      () => RevieworderController(),
    );
  }
}
