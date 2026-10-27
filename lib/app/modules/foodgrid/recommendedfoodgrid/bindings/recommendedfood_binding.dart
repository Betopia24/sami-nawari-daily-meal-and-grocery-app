import 'package:get/get.dart';
import '../controllers/recommendedfood_controller.dart';

class RecommendedfoodBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<RecommendedfoodController>()) {
      Get.delete<RecommendedfoodController>();
    }
    Get.lazyPut<RecommendedfoodController>(() => RecommendedfoodController());
  }
}
