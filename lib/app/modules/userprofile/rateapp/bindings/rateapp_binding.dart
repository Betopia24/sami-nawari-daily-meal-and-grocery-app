import 'package:get/get.dart';
import '../controllers/rateapp_controller.dart';

class RateappBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RateappController>(() => RateappController());
  }
}
