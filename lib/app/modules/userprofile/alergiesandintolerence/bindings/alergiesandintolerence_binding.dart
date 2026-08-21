import 'package:get/get.dart';
import '../controllers/alergiesandintolerence_controller.dart';

class AlergiesandintolerenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlergiesandintolerenceController>(
      () => AlergiesandintolerenceController(),
    );
  }
}
