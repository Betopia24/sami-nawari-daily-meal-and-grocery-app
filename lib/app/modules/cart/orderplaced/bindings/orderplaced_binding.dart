import 'package:get/get.dart';
import '../controllers/orderplaced_controller.dart';

class OrderplacedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderplacedController>(
      () => OrderplacedController(),
    );
  }
}
