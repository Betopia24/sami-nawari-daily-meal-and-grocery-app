import 'package:get/get.dart';

class PlaceorderController extends GetxController {
  // 0: Pay Online, 1: Cash on Delivery / Cash on Pickup
  final selectedPaymentMethod = 1.obs;

  void selectPaymentMethod(int index) {
    selectedPaymentMethod.value = index;
  }

  void onPlaceOrder() {
    // Submit order logic here
    Get.offAllNamed('/orderplaced');
  }
}
