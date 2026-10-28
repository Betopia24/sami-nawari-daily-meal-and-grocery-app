import 'package:get/get.dart';
import '../controllers/deliveryselection_controller.dart';

class DeliveryselectionBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<DeliveryselectionController>()) {
      Get.delete<DeliveryselectionController>(force: true);
    }
    Get.lazyPut<DeliveryselectionController>(
      () => DeliveryselectionController(),
    );
  }
}
