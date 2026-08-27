import 'package:get/get.dart';

import '../controllers/nutritioninstructions_controller.dart';

class NutritioninstructionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NutritioninstructionsController>(
      () => NutritioninstructionsController(),
    );
  }
}
