import 'package:get/get.dart';
import '../controllers/systempreference_controller.dart';

class SystempreferenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SystempreferenceController>(() => SystempreferenceController());
  }
}
