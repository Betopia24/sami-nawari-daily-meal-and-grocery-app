import 'package:get/get.dart';
import '../controllers/viewmenu_controller.dart';

class ViewmenuBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<ViewmenuController>()) {
      Get.delete<ViewmenuController>(force: true);
    }
    Get.put<ViewmenuController>(ViewmenuController());
  }
}
