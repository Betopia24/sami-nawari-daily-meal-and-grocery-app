import 'package:get/get.dart';

class RevieworderController extends GetxController {
  // In a real app, this data would come from a CartService or arguments.
  // We'll mock the final confirmed items based on the Figma design.

  void onContinue() {
    Get.toNamed('/deliveryselection');
  }
}
