import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/modules/navbar/controllers/navbar_controller.dart' as import_navbar;
import 'package:daily_meal_and_grocery_app/app/modules/cart/mycarts/controllers/mycarts_controller.dart' as import_mycarts;

class OrderplacedController extends GetxController {
  void onTrackMyOrder() {
    // If controllers are already in memory, update them directly
    if (Get.isRegistered<import_navbar.NavbarController>()) {
      Get.find<import_navbar.NavbarController>().changePage(3);
    }
    if (Get.isRegistered<import_mycarts.MycartsController>()) {
      Get.find<import_mycarts.MycartsController>().tabController.animateTo(1);
    }
    
    Get.offAllNamed(
      '/navbar',
      arguments: {'tab': 3, 'mycarts_tab': 1},
    );
  }

  void onBackToCart() {
    // Usually you would clear the cart and go back to home or the empty cart
    Get.offAllNamed('/navbar'); // Assuming navbar is the main home route
  }
}
