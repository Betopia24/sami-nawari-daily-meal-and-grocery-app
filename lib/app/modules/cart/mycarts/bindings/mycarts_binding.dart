import 'package:get/get.dart';
import '../controllers/mycarts_controller.dart';

class MycartsBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<MycartsController>()) {
      Get.delete<MycartsController>(force: true);
    }
    Get.lazyPut<MycartsController>(
      () => MycartsController(),
    );
  }
}
