import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/success_screen.dart';
import '../../../userprofile/systempreference/controllers/systempreference_controller.dart';

class SellerregistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final kitchenNameController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  final RxList<String> selectedCuisines = <String>[].obs;

  final List<String> availableCuisines = [
    'Mediterranean',
    'Italian',
    'Chinese',
    'Indian',
    'Mexican',
    'Other',
  ];

  // Step state
  final RxInt currentStep = 1.obs;

  // Working Hours State
  final RxBool monToFriEnabled = true.obs;
  final RxString monToFriStartTime = '9:00 AM'.obs;
  final RxString monToFriEndTime = '6:00 PM'.obs;

  final RxBool saturdayEnabled = true.obs;
  final RxString saturdayStartTime = '10:00 AM'.obs;
  final RxString saturdayEndTime = '4:00 PM'.obs;

  final RxBool sundayEnabled = false.obs;
  final RxString sundayStartTime = '10:00 AM'.obs;
  final RxString sundayEndTime = '4:00 PM'.obs;

  final List<String> timeOptions = [
    '7:00 AM',
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
    '6:00 PM',
    '7:00 PM',
    '8:00 PM',
    '9:00 PM',
    '10:00 PM',
  ];

  // Delivery Method State
  final RxBool pickupAvailable = true.obs;
  final RxBool deliveryAvailable = false.obs;

  // Step 3: Verify Your Identity
  final RxString governmentIdPath = ''.obs;

  void onCuisinesChanged(List<String> cuisines) {
    selectedCuisines.value = cuisines;
  }

  void continueToNextStep() {
    if (currentStep.value == 1) {
      if (formKey.currentState!.validate()) {
        currentStep.value = 2;
      }
    } else if (currentStep.value == 2) {
      currentStep.value = 3;
    } else if (currentStep.value == 3) {
      currentStep.value = 4;
    } else if (currentStep.value == 4) {
      // Submit Application
      Get.to(
        () => SuccessScreen(
          title: 'Application Submitted!',
          message:
              'Your kitchen has been submitted for review. Our team will verify your application within **2-3 business days**. You\'ll receive a notification once approved.',
          graphicPath: 'assets/graphics/submit_graphic.svg',
          buttonText: 'Back to Profile',
          onButtonPressed: () {
            Get.until((route) => route.settings.name == Routes.navbar);
            if (Get.isRegistered<SystempreferenceController>()) {
              final prefController = Get.find<SystempreferenceController>();
              prefController.isRegisteredSeller.value = true;
              prefController.isSellerMode.value = true;
            }
          },
        ),
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    kitchenNameController.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
