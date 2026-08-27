import 'package:get/get.dart';

class ReviewbankdetailsController extends GetxController {
  // Logic for adding bank account would go here

  void editDetails() {
    Get.back();
  }

  void addBankAccount() {
    // Save logic
    // Show success snackbar
    Get.snackbar(
      'Success',
      'Bank account added successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
    // Close ReviewBankDetails and AddBankAccount screens to return to the previous screen
    Get.close(2);
  }
}
