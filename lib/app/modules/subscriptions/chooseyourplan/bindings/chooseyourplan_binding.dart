import 'package:get/get.dart';
import '../controllers/chooseyourplan_controller.dart';

class ChooseyourplanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseyourplanController>(
      () => ChooseyourplanController(),
    );
  }
}
