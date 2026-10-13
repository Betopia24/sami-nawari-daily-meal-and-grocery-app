import 'package:get/get.dart';
import '../controllers/viewmenu_controller.dart';

class ViewmenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewmenuController>(() => ViewmenuController());
  }
}
