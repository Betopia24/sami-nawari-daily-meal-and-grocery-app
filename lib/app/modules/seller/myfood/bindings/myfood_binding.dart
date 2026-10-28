import 'package:get/get.dart';
import '../controllers/myfood_controller.dart';

class MyFoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyFoodController>(
      () => MyFoodController(),
    );
  }
}
