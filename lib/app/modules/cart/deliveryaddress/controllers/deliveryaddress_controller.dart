import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class DeliveryaddressController extends GetxController {
  final streetController = TextEditingController();
  final aptController = TextEditingController();
  final cityController = TextEditingController();
  final notesController = TextEditingController();

  final isFormValid = false.obs;
  final isLoadingProfile = false.obs;

  @override
  void onInit() {
    super.onInit();
    streetController.addListener(_validateForm);
    cityController.addListener(_validateForm);
    
    // Dynamically load user's saved profile address (NO static dummy data)
    _loadUserSavedAddress();
  }

  Future<void> _loadUserSavedAddress() async {
    try {
      isLoadingProfile.value = true;
      final response = await NetworkCaller.getRequest(Urls.userMe);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final data = body is Map ? (body['data'] ?? body) : null;
        if (data is Map) {
          final addr = (data['address'] ?? data['streetAddress'] ?? '').toString();
          final userCity = (data['city'] ?? '').toString();
          if (addr.isNotEmpty) {
            streetController.text = addr;
          }
          if (userCity.isNotEmpty) {
            cityController.text = userCity;
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading user address: $e');
    } finally {
      isLoadingProfile.value = false;
      _validateForm();
    }
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
