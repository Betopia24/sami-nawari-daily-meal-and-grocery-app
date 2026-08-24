import 'package:get/get.dart';
import '../controllers/deliveryaddress_controller.dart';

class DeliveryaddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryaddressController>(
      () => DeliveryaddressController(),
    );
  }
}
