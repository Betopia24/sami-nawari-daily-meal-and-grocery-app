import 'package:get/get.dart';
import '../controllers/snacksreceipes_controller.dart';

class SnacksreceipesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SnacksreceipesController>(
      () => SnacksreceipesController(),
    );
  }
}
