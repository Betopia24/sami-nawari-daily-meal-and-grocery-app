import 'package:get/get.dart';
import '../controllers/appsharing_controller.dart';

class AppsharingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppsharingController>(() => AppsharingController());
  }
}
