import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/modules/nutritions/creationsteps/controllers/creationsteps_controller.dart';

class CreationstepsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreationstepsController>(
      () => CreationstepsController(),
    );
  }
}
