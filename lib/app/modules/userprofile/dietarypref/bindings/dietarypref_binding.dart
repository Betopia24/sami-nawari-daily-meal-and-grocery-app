import 'package:get/get.dart';
import '../controllers/dietarypref_controller.dart';

class DietaryprefBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DietaryprefController>(() => DietaryprefController());
  }
}
