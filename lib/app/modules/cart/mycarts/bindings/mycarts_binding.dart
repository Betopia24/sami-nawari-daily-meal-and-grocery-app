import 'package:get/get.dart';
import '../controllers/mycarts_controller.dart';

class MycartsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MycartsController>(
      () => MycartsController(),
    );
  }
}
