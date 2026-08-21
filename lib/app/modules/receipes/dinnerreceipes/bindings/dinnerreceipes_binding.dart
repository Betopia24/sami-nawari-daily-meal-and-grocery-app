import 'package:get/get.dart';
import '../controllers/dinnerreceipes_controller.dart';

class DinnerreceipesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DinnerreceipesController>(() => DinnerreceipesController());
  }
}
