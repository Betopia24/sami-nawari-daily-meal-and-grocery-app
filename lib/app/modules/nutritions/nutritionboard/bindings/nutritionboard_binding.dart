import 'package:get/get.dart';
import '../controllers/nutritionboard_controller.dart';

class NutritionboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NutritionboardController>(() => NutritionboardController());
  }
}
