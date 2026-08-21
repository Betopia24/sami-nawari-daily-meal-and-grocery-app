import 'package:get/get.dart';
import '../controllers/foodpreferences_controller.dart';

class FoodpreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodpreferencesController>(() => FoodpreferencesController());
  }
}
