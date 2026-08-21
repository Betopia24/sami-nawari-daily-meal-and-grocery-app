import 'package:get/get.dart';
import '../controllers/savedreceipe_controller.dart';

class SavedreceipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedreceipeController>(() => SavedreceipeController());
  }
}
