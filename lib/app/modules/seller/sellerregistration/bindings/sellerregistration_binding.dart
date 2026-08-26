import 'package:get/get.dart';
import '../controllers/sellerregistration_controller.dart';

class SellerregistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerregistrationController>(
      () => SellerregistrationController(),
    );
  }
}
