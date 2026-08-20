import 'package:get/get.dart';
import '../controllers/breakfastreceipes_controller.dart';

class BreakfastreceipesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BreakfastreceipesController>(
      () => BreakfastreceipesController(),
    );
  }
}
