import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/modules/nutritions/mealplan/controllers/mealplan_controller.dart';

class MealplanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealplanController>(
      () => MealplanController(),
    );
  }
}
