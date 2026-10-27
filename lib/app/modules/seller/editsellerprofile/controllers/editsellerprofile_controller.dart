import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/seller_profile_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../widgets/custom_time_dropdown.dart';

class EditsellerprofileController extends GetxController {
  // Image Selection
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString existingImageUrl = ''.obs;
  final ImagePicker _picker = ImagePicker();
  final RxBool isLoading = false.obs;

  // Basic Info
  final fullNameController = TextEditingController();
  final kitchenNameController = TextEditingController();
  final descriptionController = TextEditingController();

  // Contact & Location
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  // Cuisines
  final RxList<String> availableCuisines = [
    'Filipino', 'American', 'Italian', 'Japanese',
    'Chinese', 'Korean', 'Mexican', 'Indian',
    'Thai', 'Vietnamese', 'Mediterranean', 'Vegetarian',
    'Vegan', 'Halal', 'Desserts', 'Beverages'
  ].obs;
  final RxSet<String> selectedCuisines = <String>{}.obs;

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
  void onInit() {
    super.onInit();
    fetchSellerProfile();
  }

  Future<void> fetchSellerProfile() async {
    isLoading.value = true;
    try {
      final response = await NetworkCaller.getRequest(Urls.sellerProfileMe);
      if (response.isSuccess && response.responseData != null) {
        final profileResponse =
            SellerProfileResponseModel.fromJson(response.responseData);
        final data = profileResponse.data;
        if (data != null) {
          if (data.ownerName?.isNotEmpty == true) {
            fullNameController.text = data.ownerName!;
          } else if (data.user?.name?.isNotEmpty == true) {
            fullNameController.text = data.user!.name!;
          }
          if (data.businessName?.isNotEmpty == true) {
            kitchenNameController.text = data.businessName!;
          }
          if (data.description?.isNotEmpty == true) {
            descriptionController.text = data.description!;
          }
          if (data.user?.email?.isNotEmpty == true) {
            emailController.text = data.user!.email!;
          }
          if (data.phone?.isNotEmpty == true) {
            phoneController.text = data.phone!;
          }
          if (data.address?.isNotEmpty == true) {
            locationController.text = data.address!;
          }
          if (data.cuisineTypes.isNotEmpty) {
            selectedCuisines.assignAll(data.cuisineTypes);
            for (var c in data.cuisineTypes) {
              if (!availableCuisines.contains(c)) {
                availableCuisines.add(c);
              }
            }
          }
          if (data.avatarUrl?.isNotEmpty == true) {
            existingImageUrl.value = data.avatarUrl!;
          }
          if (data.deliveryAvailable != null) {
            deliverySupportEnabled.value = data.deliveryAvailable!;
          }
          if (data.pickupAvailable != null) {
            pickupSupportEnabled.value = data.pickupAvailable!;
          }
          if (data.workingHours != null) {
            if (data.workingHours!.monFri != null) {
              monToFriEnabled.value = data.workingHours!.monFri!.isOpen ?? true;
              if (data.workingHours!.monFri!.open?.isNotEmpty == true) {
                monToFriStartTime.value =
                    CustomTimeDropdown.formatTo12Hour(data.workingHours!.monFri!.open!);
              }
              if (data.workingHours!.monFri!.close?.isNotEmpty == true) {
                monToFriEndTime.value =
                    CustomTimeDropdown.formatTo12Hour(data.workingHours!.monFri!.close!);
              }
            }
            if (data.workingHours!.saturday != null) {
              saturdayEnabled.value = data.workingHours!.saturday!.isOpen ?? true;
              if (data.workingHours!.saturday!.open?.isNotEmpty == true) {
                saturdayStartTime.value =
                    CustomTimeDropdown.formatTo12Hour(data.workingHours!.saturday!.open!);
              }
              if (data.workingHours!.saturday!.close?.isNotEmpty == true) {
                saturdayEndTime.value =
                    CustomTimeDropdown.formatTo12Hour(data.workingHours!.saturday!.close!);
              }
            }
            if (data.workingHours!.sunday != null) {
              sundayEnabled.value = data.workingHours!.sunday!.isOpen ?? false;
              if (data.workingHours!.sunday!.open?.isNotEmpty == true) {
                sundayStartTime.value =
                    CustomTimeDropdown.formatTo12Hour(data.workingHours!.sunday!.open!);
              }
              if (data.workingHours!.sunday!.close?.isNotEmpty == true) {
                sundayEndTime.value =
                    CustomTimeDropdown.formatTo12Hour(data.workingHours!.sunday!.close!);
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching seller profile in EditSellerProfile: $e');
    } finally {
      isLoading.value = false;
    }
  }

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

  void addCustomCuisine(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final formatted = trimmed.length == 1
        ? trimmed.toUpperCase()
        : '${trimmed[0].toUpperCase()}${trimmed.substring(1)}';

    if (!availableCuisines.contains(formatted)) {
      availableCuisines.add(formatted);
    }
    if (!selectedCuisines.contains(formatted)) {
      selectedCuisines.add(formatted);
    }
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
