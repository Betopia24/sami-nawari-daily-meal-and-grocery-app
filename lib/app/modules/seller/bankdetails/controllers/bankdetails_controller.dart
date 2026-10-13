import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankdetailsController extends GetxController {
  final accountHolderNameController = TextEditingController(text: 'Rafiul Islam');
  final bankNameController = TextEditingController(text: 'City Bank Limited');
  final accountNumberController = TextEditingController(text: '1234 5678 9012 3456');
  final routingNumberController = TextEditingController(text: '065132987');
  final swiftCodeController = TextEditingController(text: 'CIBKBDDH');

  final accountType = 'Savings Account'.obs;
  final currency = 'USD - US Dollar'.obs;

  @override
  void onClose() {
    accountHolderNameController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    routingNumberController.dispose();
    swiftCodeController.dispose();
    super.onClose();
  }

  void editDetails() {
    // Navigate to edit details or enable editing mode
  }

  void removeBankAccount() {
    // Logic to remove bank account
  }
}
