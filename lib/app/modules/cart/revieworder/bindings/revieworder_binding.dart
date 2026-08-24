import 'package:get/get.dart';
import '../controllers/revieworder_controller.dart';

class RevieworderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RevieworderController>(
      () => RevieworderController(),
    );
  }
}
