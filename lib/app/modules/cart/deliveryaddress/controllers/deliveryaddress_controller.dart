import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryaddressController extends GetxController {
  final streetController = TextEditingController();
  final aptController = TextEditingController();
  final cityController = TextEditingController();
  final notesController = TextEditingController();

  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    streetController.addListener(_validateForm);
    cityController.addListener(_validateForm);
    
    // Pre-fill mock data from design
    streetController.text = '123 Main Street';
    aptController.text = 'Apt 4B';
    cityController.text = 'San Francisco';
    notesController.text = 'Ring doorbell, leave at door...';
    _validateForm();
  }

  void _validateForm() {
    isFormValid.value = streetController.text.trim().isNotEmpty &&
        cityController.text.trim().isNotEmpty;
  }

  void onContinue() {
    if (isFormValid.value) {
      Get.toNamed('/placeorder');
    }
  }

  @override
  void onClose() {
    streetController.dispose();
    aptController.dispose();
    cityController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
