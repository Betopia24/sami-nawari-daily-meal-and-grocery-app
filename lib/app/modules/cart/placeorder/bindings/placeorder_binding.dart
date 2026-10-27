import 'package:get/get.dart';
import '../controllers/placeorder_controller.dart';

class PlaceorderBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<PlaceorderController>()) {
      Get.delete<PlaceorderController>();
    }
    Get.lazyPut<PlaceorderController>(
      () => PlaceorderController(),
    );
  }
}
