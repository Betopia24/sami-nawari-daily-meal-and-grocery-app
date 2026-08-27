import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/modules/nutritions/planready/controllers/planready_controller.dart';

class PlanreadyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanreadyController>(
      () => PlanreadyController(),
    );
  }
}
