import 'package:get/get.dart';
import '../controllers/groceries_controller.dart';

class GroceriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroceriesController>(
      () => GroceriesController(),
    );
  }
}
