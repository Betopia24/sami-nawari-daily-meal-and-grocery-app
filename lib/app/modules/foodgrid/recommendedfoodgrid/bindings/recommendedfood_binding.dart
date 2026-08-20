import 'package:get/get.dart';
import '../controllers/recommendedfood_controller.dart';

class RecommendedfoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecommendedfoodController>(() => RecommendedfoodController());
  }
}
