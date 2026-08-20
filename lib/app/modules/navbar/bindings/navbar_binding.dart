import 'package:get/get.dart';
import '../controllers/navbar_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarController>(() => NavbarController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
