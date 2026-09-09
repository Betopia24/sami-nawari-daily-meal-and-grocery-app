import 'package:get/get.dart';
import '../controllers/navbar_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../userprofile/systempreference/controllers/systempreference_controller.dart';
import '../../nutritions/nutritionboard/controllers/nutritionboard_controller.dart';

import '../../groceries/controllers/groceries_controller.dart';
import '../../explore/exploreboard/controllers/exploreboard_controller.dart';

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarController>(() => NavbarController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<SystempreferenceController>(() => SystempreferenceController());
    Get.lazyPut<NutritionboardController>(() => NutritionboardController());
    Get.lazyPut<GroceriesController>(() => GroceriesController());
    Get.lazyPut<ExploreboardController>(() => ExploreboardController());
  }
}
