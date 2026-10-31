import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' hide Response;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/seller_profile_model.dart';
import '../../../../data/network/local_storage.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../widgets/custom_time_dropdown.dart';
import '../../../userprofile/systempreference/controllers/systempreference_controller.dart';

class EditsellerprofileController extends GetxController {
  // Image Selection
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString existingImageUrl = ''.obs;
  final ImagePicker _picker = ImagePicker();
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  // Basic Info
  final fullNameController = TextEditingController();
  final kitchenNameController = TextEditingController();
  final descriptionController = TextEditingController();

  // Contact & Location
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  // Cuisines supported by backend enum
  static const Set<String> validBackendEnumCuisines = {
    'MEDITERRANEAN',
    'ITALIAN',
    'CHINESE',
    'INDIAN',
    'MEXICAN',
    'OTHER',
  };

  final RxList<String> availableCuisines = [
    'Mediterranean',
    'Italian',
    'Chinese',
    'Indian',
    'Mexican',
    'Other',
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
      debugPrint('[GET /seller/profile/me] Server Data: ${response.responseData}');
      if (response.isSuccess && response.responseData != null) {
        final profileResponse =
            SellerProfileResponseModel.fromJson(response.responseData);
        final data = profileResponse.data;
        if (data != null) {
          final sellerRole = data.user?.role;
          if (sellerRole != null && sellerRole.isNotEmpty) {
            await LocalStorage.saveRole(sellerRole);
          }
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
            final mappedList = data.cuisineTypes
                .map((c) => formatCuisineDisplayName(c))
                .toList();
            selectedCuisines.assignAll(mappedList);
            for (var c in mappedList) {
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

  String _to24Hour(String timeStr) {
    if (timeStr.trim().isEmpty || timeStr.trim().toLowerCase() == 'closed') {
      return '';
    }
    try {
      final trimmed = timeStr.trim().toUpperCase();
      final isPm = trimmed.contains('PM');
      final isAm = trimmed.contains('AM');
      final cleanTime =
          trimmed.replaceAll('AM', '').replaceAll('PM', '').trim();
      final parts = cleanTime.split(':');
      if (parts.isNotEmpty) {
        int hour = int.parse(parts[0]);
        int minute = parts.length > 1 ? int.parse(parts[1]) : 0;
        if (isPm && hour != 12) hour += 12;
        if (isAm && hour == 12) hour = 0;
        return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      }
    } catch (_) {}
    return timeStr;
  }

  String _formatDayTime(
    bool isDayOpen,
    String timeStr, {
    required String defaultTime,
  }) {
    if (!isDayOpen) {
      return '00:00';
    }
    if (timeStr.trim().isEmpty || timeStr.trim().toLowerCase() == 'closed') {
      return defaultTime;
    }
    final formatted = _to24Hour(timeStr);
    return formatted.isNotEmpty ? formatted : defaultTime;
  }

  static String formatCuisineDisplayName(String raw) {
    final upper = raw.trim().toUpperCase();
    switch (upper) {
      case 'MEDITERRANEAN':
        return 'Mediterranean';
      case 'ITALIAN':
        return 'Italian';
      case 'CHINESE':
        return 'Chinese';
      case 'INDIAN':
        return 'Indian';
      case 'MEXICAN':
        return 'Mexican';
      case 'OTHER':
        return 'Other';
      default:
        if (raw.isNotEmpty) {
          return raw[0].toUpperCase() + raw.substring(1).toLowerCase();
        }
        return 'Other';
    }
  }

  static String mapToBackendCuisine(String raw) {
    final upper = raw.trim().toUpperCase();
    if (validBackendEnumCuisines.contains(upper)) {
      return upper;
    }
    return 'OTHER';
  }

  /// Sends PATCH request to Urls.sellerProfileMe ('/seller/profile/me')
  Future<void> saveChanges() async {
    // Validate
    if (kitchenNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Kitchen/Business Name is required',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    isSaving.value = true;

    try {
      final List<String> formattedCuisines = selectedCuisines
          .map((c) => mapToBackendCuisine(c))
          .toSet()
          .toList();
      if (formattedCuisines.isEmpty) {
        formattedCuisines.add('OTHER');
      }

      final Map<String, dynamic> body = {
        'businessName': kitchenNameController.text.trim(),
        'ownerName': fullNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'description': descriptionController.text.trim(),
        'address': locationController.text.trim(),
        'cuisineTypes': formattedCuisines,
        'pickupAvailable': pickupSupportEnabled.value,
        'deliveryAvailable': deliverySupportEnabled.value,
        if (deliveryFeeController.text.trim().isNotEmpty)
          'deliveryFee':
              double.tryParse(deliveryFeeController.text.trim()) ?? 0.0,
        'workingHours': {
          'mon_fri': {
            'open': _formatDayTime(
              monToFriEnabled.value,
              monToFriStartTime.value,
              defaultTime: '09:00',
            ),
            'close': _formatDayTime(
              monToFriEnabled.value,
              monToFriEndTime.value,
              defaultTime: '20:00',
            ),
            'isOpen': monToFriEnabled.value,
          },
          'saturday': {
            'open': _formatDayTime(
              saturdayEnabled.value,
              saturdayStartTime.value,
              defaultTime: '10:00',
            ),
            'close': _formatDayTime(
              saturdayEnabled.value,
              saturdayEndTime.value,
              defaultTime: '18:00',
            ),
            'isOpen': saturdayEnabled.value,
          },
          'sunday': {
            'open': _formatDayTime(
              sundayEnabled.value,
              sundayStartTime.value,
              defaultTime: '00:00',
            ),
            'close': _formatDayTime(
              sundayEnabled.value,
              sundayEndTime.value,
              defaultTime: '00:00',
            ),
            'isOpen': sundayEnabled.value,
          },
        },
      };

      dynamic payload = body;
      if (selectedImage.value != null) {
        try {
          final formData = FormData.fromMap({
            ...body,
            'image': await MultipartFile.fromFile(
              selectedImage.value!.path,
              filename: selectedImage.value!.path.split('/').last,
            ),
          });
          payload = formData;
        } catch (_) {
          payload = body;
        }
      }

      log('====================================================');
      log('[PATCH /seller/profile/me] INITIATING REQUEST');
      log('URL: ${Urls.baseUrl}${Urls.sellerProfileMe}');
      log('JSON Payload: ${jsonEncode(body)}');
      log('Has Selected Image: ${selectedImage.value != null}');
      log('====================================================');
      debugPrint('[PATCH /seller/profile/me] Request Payload: ${jsonEncode(body)}');

      final response = await NetworkCaller.patchRequest(
        Urls.sellerProfileMe,
        body: payload,
      );

      log('====================================================');
      log('[PATCH /seller/profile/me] RESPONSE RECEIVED');
      log('Status Code: ${response.statusCode}');
      log('Is Success: ${response.isSuccess}');
      log('Response Data: ${response.responseData}');
      log('Success Message: ${response.successMessage}');
      log('Error Message: ${response.errorMessage}');
      log('====================================================');
      debugPrint(
          '[PATCH /seller/profile/me] StatusCode: ${response.statusCode}, isSuccess: ${response.isSuccess}');
      debugPrint('[PATCH /seller/profile/me] Response: ${response.responseData}');
      debugPrint('[PATCH /seller/profile/me] Error: ${response.errorMessage}');

      if (response.isSuccess) {
        // Refresh active seller profile in SystempreferenceController if open
        if (Get.isRegistered<SystempreferenceController>()) {
          Get.find<SystempreferenceController>().fetchSellerProfile();
        }

        // Navigate back immediately
        Get.back();

        Get.snackbar(
          'Success',
          response.successMessage?.isNotEmpty == true
              ? response.successMessage!
              : 'Profile updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.snackbar(
          'Update Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update profile. Check console for details.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e, stackTrace) {
      log('====================================================');
      log('[PATCH /seller/profile/me] EXCEPTION CAUGHT: $e');
      log('Stack Trace: $stackTrace');
      log('====================================================');
      debugPrint('[PATCH /seller/profile/me] Exception: $e');

      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isSaving.value = false;
    }
  }
}
