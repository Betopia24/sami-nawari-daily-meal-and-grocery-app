import 'package:get/get.dart';
import '../controllers/deliveryselection_controller.dart';

class DeliveryselectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryselectionController>(
      () => DeliveryselectionController(),
    );
  }
}
