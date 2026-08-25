import 'package:get/get.dart';
import '../controllers/navbar_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../userprofile/systempreference/controllers/systempreference_controller.dart';
import '../../cart/mycarts/controllers/mycarts_controller.dart';

import '../../groceries/controllers/groceries_controller.dart';

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarController>(() => NavbarController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<SystempreferenceController>(() => SystempreferenceController());
    Get.lazyPut<MycartsController>(() => MycartsController());
    Get.lazyPut<GroceriesController>(() => GroceriesController());
  }
}
