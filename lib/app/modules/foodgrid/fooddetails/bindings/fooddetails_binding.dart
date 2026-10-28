import 'package:get/get.dart';

import '../controllers/fooddetails_controller.dart';

class FooddetailsBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<FooddetailsController>()) {
      Get.delete<FooddetailsController>(force: true);
    }
    Get.put<FooddetailsController>(FooddetailsController());
  }
}
