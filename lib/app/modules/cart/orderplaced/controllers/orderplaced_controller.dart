import 'package:get/get.dart';

class OrderplacedController extends GetxController {
  void onTrackMyOrder() {
    Get.offNamed('/trackorder');
  }

  void onBackToCart() {
    // Usually you would clear the cart and go back to home or the empty cart
    Get.offAllNamed('/navbar'); // Assuming navbar is the main home route
  }
}
