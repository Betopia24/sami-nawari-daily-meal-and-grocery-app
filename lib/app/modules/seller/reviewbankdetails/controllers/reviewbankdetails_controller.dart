import 'package:get/get.dart';

class ReviewbankdetailsController extends GetxController {
  // Logic for adding bank account would go here

  void editDetails() {
    Get.back();
  }

  void addBankAccount() {
    // Save logic
    // For now, go back to Payment Information page or show success
    Get.until((route) => route.settings.name == '/paymentinformation');
  }
}
