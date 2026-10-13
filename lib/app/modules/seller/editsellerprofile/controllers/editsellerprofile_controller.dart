import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditsellerprofileController extends GetxController {
  // Image Selection
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // Basic Info
  final fullNameController = TextEditingController();
  final kitchenNameController = TextEditingController(text: "Maria's Kitchen");
  final descriptionController = TextEditingController(text: "Authentic homemade meals made with love.");

  // Contact & Location
  final emailController = TextEditingController();
  final phoneController = TextEditingController(text: "+63 912 345 6789");
  final locationController = TextEditingController(text: "123 Market St, San Francisco, CA");

  // Cuisines
  final RxList<String> availableCuisines = [
    'Filipino', 'American', 'Italian', 'Japanese',
    'Chinese', 'Korean', 'Mexican', 'Indian',
    'Thai', 'Vietnamese', 'Mediterranean', 'Vegetarian',
    'Vegan', 'Halal', 'Desserts', 'Beverages'
  ].obs;
  final RxSet<String> selectedCuisines = {'Filipino', 'Desserts'}.obs;

  // Working Hours (Toggles)
  final monToFriEnabled = true.obs;
  final saturdayEnabled = true.obs;
  final sundayEnabled = false.obs;

  // Working Hours (Times)
  final monToFriStartTime = '09:00 AM'.obs;
  final monToFriEndTime = '08:00 PM'.obs;
  final saturdayStartTime = '10:00 AM'.obs;
  final saturdayEndTime = '09:00 PM'.obs;
  final sundayStartTime = 'Closed'.obs;
  final sundayEndTime = 'Closed'.obs;

  final timeOptions = [
    'Closed',
    '07:00 AM', '08:00 AM', '09:00 AM', '10:00 AM',
    '11:00 AM', '12:00 PM', '01:00 PM', '02:00 PM',
    '03:00 PM', '04:00 PM', '05:00 PM', '06:00 PM',
    '07:00 PM', '08:00 PM', '09:00 PM', '10:00 PM',
    '11:00 PM', '12:00 AM'
  ];

  // Services
  final deliverySupportEnabled = true.obs;
  final pickupSupportEnabled = true.obs;
  
  final deliveryFeeController = TextEditingController(text: "50");
  final deliveryTimeController = TextEditingController(text: "45");
  final pickupTimeController = TextEditingController(text: "30");

  @override
  void onClose() {
    fullNameController.dispose();
    kitchenNameController.dispose();
    descriptionController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    deliveryFeeController.dispose();
    deliveryTimeController.dispose();
    pickupTimeController.dispose();
    super.onClose();
  }

  void onCuisinesChanged(List<String> cuisines) {
    selectedCuisines.assignAll(cuisines);
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress slightly
      );
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }

  void saveChanges() {
    // Validate and save
    if (kitchenNameController.text.isEmpty) {
      Get.snackbar('Error', 'Kitchen Name is required');
      return;
    }
    
    // Simulate save
    Get.back();
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      backgroundColor: Colors.green.withValues(alpha: 0.1),
      colorText: Colors.green,
    );
  }
}
