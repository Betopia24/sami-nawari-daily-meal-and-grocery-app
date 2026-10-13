import 'package:get/get.dart';

class DeliveryselectionController extends GetxController {
  // Store the selected delivery method for each restaurant index
  // For example: 0 for Pickup, 1 for Delivery
  // Mock data: Maria's kitchen only has pickup (0), Luca's has pickup/delivery (defaults to 0), Priya's has both (defaults to 1)
  final selectedMethods = <int, int>{
    0: 0, // Maria's
    1: 0, // Luca's
    2: 1, // Priya's
  }.obs;

  void selectMethod(int restaurantIndex, int methodIndex) {
    selectedMethods[restaurantIndex] = methodIndex;
  }

  void onContinue() {
    Get.toNamed('/deliveryaddress');
  }
}
