import 'package:get/get.dart';
import '../controllers/lunchreceipes_controller.dart';

class LunchreceipesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LunchreceipesController>(() => LunchreceipesController());
  }
}
