import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

import '../../../../data/network/local_storage.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../userprofile/systempreference/controllers/systempreference_controller.dart';
import '../../widgets/admin_approval_dialog.dart';
import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';

class SellerregistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final kitchenNameController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  final RxList<String> selectedCuisines = <String>[].obs;
  final RxList<String> kitchenImages = <String>[].obs;
  final ImagePicker _picker = ImagePicker();

  // Loading state for API submission
  final RxBool isLoading = false.obs;

  // Geo-coordinates (dynamically resolved from user address via geocoding)
  final RxDouble latitude = 37.7879.obs;
  final RxDouble longitude = (-122.3999).obs;

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

  @override
  void onInit() {
    super.onInit();
    _loadInitialUserData();
  }

  /// Pre-fill owner name and phone from stored user session if available
  Future<void> _loadInitialUserData() async {
    try {
      final user = await LocalStorage.getUser();
      if (user != null) {
        if (fullNameController.text.isEmpty && user['name'] != null) {
          fullNameController.text = user['name'].toString();
        }
        if (phoneNumberController.text.isEmpty && user['phone'] != null) {
          phoneNumberController.text = user['phone'].toString();
        }
        if (locationController.text.isEmpty && user['address'] != null) {
          locationController.text = user['address'].toString();
          resolveCoordinatesFromAddress(locationController.text.trim());
        }
      }
    } catch (e) {
      debugPrint('Error loading initial user data: $e');
    }
  }

  Future<void> pickKitchenImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        kitchenImages.add(image.path);
      }
    } catch (e) {
      debugPrint('Error picking kitchen image: $e');
    }
  }

  void removeKitchenImage(int index) {
    if (index >= 0 && index < kitchenImages.length) {
      kitchenImages.removeAt(index);
    }
  }

  Future<void> pickGovernmentId() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        governmentIdPath.value = image.path;
      }
    } catch (e) {
      debugPrint('Error picking government ID: $e');
      Get.snackbar(
        'Upload Error',
        'Could not pick file: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeGovernmentId() {
    governmentIdPath.value = '';
  }

  void onCuisinesChanged(List<String> cuisines) {
    selectedCuisines.value = cuisines;
  }

  /// Resolves latitude and longitude coordinates from an address string
  /// Uses OpenStreetMap Nominatim HTTP lookup first (safe, non-blocking), then native geocoding with timeout
  Future<void> resolveCoordinatesFromAddress(String addressStr) async {
    final cleanAddress = addressStr.trim();
    if (cleanAddress.isEmpty) return;

    // 1. First attempt: OpenStreetMap Nominatim API (async HTTP via Dio - never blocks Android main looper)
    try {
      final client = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          headers: {'User-Agent': 'DailyMealAndGroceryApp/1.0'},
        ),
      );
      final encoded = Uri.encodeComponent(cleanAddress);
      final res = await client.get(
        'https://nominatim.openstreetmap.org/search?q=$encoded&format=json&limit=1',
      );
      if (res.statusCode == 200 && res.data is List && (res.data as List).isNotEmpty) {
        final item = (res.data as List).first;
        final lat = double.tryParse(item['lat']?.toString() ?? '');
        final lon = double.tryParse(item['lon']?.toString() ?? '');
        if (lat != null && lon != null) {
          latitude.value = lat;
          longitude.value = lon;
          debugPrint(
              'HTTP Nominatim resolved for "$cleanAddress": (${latitude.value}, ${longitude.value})');
          return;
        }
      }
    } catch (e) {
      debugPrint('HTTP Nominatim geocoding failed: $e');
    }

    // 2. Secondary fallback: native geocoding package protected with a strict 2s timeout
    try {
      final geocoding = Geocoding();
      final List<Location> locations = await geocoding
          .locationFromAddress(cleanAddress)
          .timeout(const Duration(seconds: 2));
      if (locations.isNotEmpty) {
        latitude.value = locations.first.latitude;
        longitude.value = locations.first.longitude;
        debugPrint(
            'Native geocoding resolved for "$cleanAddress": (${latitude.value}, ${longitude.value})');
        return;
      }
    } catch (e) {
      debugPrint('Native geocoding timed out or failed: $e');
    }
  }

  /// Converts 12-hour formatted time (e.g., "8:00 AM", "6:00 PM") to 24-hour string format ("08:00", "18:00")
  String _to24Hour(String timeStr) {
    if (timeStr.trim().isEmpty) return '';
    try {
      final trimmed = timeStr.trim().toUpperCase();
      final isPm = trimmed.contains('PM');
      final isAm = trimmed.contains('AM');
      final cleanTime = trimmed.replaceAll('AM', '').replaceAll('PM', '').trim();
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

  Future<void> continueToNextStep() async {
    if (currentStep.value == 1) {
      if (formKey.currentState!.validate()) {
        if (selectedCuisines.isEmpty) {
          Get.snackbar(
            'Cuisine Required',
            'Please select at least one cuisine type',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
          );
          return;
        }
        // Asynchronously resolve coordinates when finishing step 1
        resolveCoordinatesFromAddress(locationController.text.trim());
        currentStep.value = 2;
      }
    } else if (currentStep.value == 2) {
      currentStep.value = 3;
    } else if (currentStep.value == 3) {
      currentStep.value = 4;
    } else if (currentStep.value == 4) {
      submitSellerRequest();
    }
  }

  /// Executes POST request to Urls.sellerRequest (/seller/request)
  Future<void> submitSellerRequest() async {
    if (isLoading.value) return;

    // Determine attached Government ID file
    final String? idFilePath = governmentIdPath.value.isNotEmpty
        ? governmentIdPath.value
        : (kitchenImages.isNotEmpty ? kitchenImages.first : null);

    if (idFilePath == null || idFilePath.isEmpty) {
      Get.snackbar(
        'Document Required',
        'Please upload your Government ID to complete registration.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Ensure coordinates are resolved from the user's address
      if (locationController.text.trim().isNotEmpty) {
        await resolveCoordinatesFromAddress(locationController.text.trim());
      }

      final Map<String, dynamic> dataPayload = {
        "businessName": kitchenNameController.text.trim(),
        "ownerName": fullNameController.text.trim(),
        "phone": phoneNumberController.text.trim(),
        "cuisineTypes": selectedCuisines.isEmpty
            ? ["INDIAN", "CHINESE"]
            : selectedCuisines.map((c) => c.toUpperCase()).toList(),
        "description": descriptionController.text.trim(),
        "address": locationController.text.trim(),
        "latitude": latitude.value,
        "longitude": longitude.value,
        "location": {
          "type": "Point",
          "coordinates": [
            longitude.value,
            latitude.value,
          ],
        },
        "workingHours": {
          "mon_fri": {
            "open": monToFriEnabled.value ? _to24Hour(monToFriStartTime.value) : "",
            "close": monToFriEnabled.value ? _to24Hour(monToFriEndTime.value) : "",
            "isOpen": monToFriEnabled.value,
          },
          "saturday": {
            "open": saturdayEnabled.value ? _to24Hour(saturdayStartTime.value) : "",
            "close": saturdayEnabled.value ? _to24Hour(saturdayEndTime.value) : "",
            "isOpen": saturdayEnabled.value,
          },
          "sunday": {
            "open": sundayEnabled.value ? _to24Hour(sundayStartTime.value) : "",
            "close": sundayEnabled.value ? _to24Hour(sundayEndTime.value) : "",
            "isOpen": sundayEnabled.value,
          },
        },
        "pickupAvailable": pickupAvailable.value,
        "deliveryAvailable": deliveryAvailable.value,
      };

      // Construct multipart FormData matching Postman collection:
      // 1. data: stringified JSON
      // 2. file: Government ID document
      // 3. kitchenImages: Multiple kitchen photos
      final FormData formData = FormData();

      // Field "data" (JSON string)
      formData.fields.add(MapEntry("data", jsonEncode(dataPayload)));

      // Field "file" (Government ID)
      formData.files.add(
        MapEntry(
          "file",
          await MultipartFile.fromFile(
            idFilePath,
            filename: idFilePath.split('/').last,
          ),
        ),
      );

      // Field "kitchenImages" (Multiple kitchen images)
      for (final imgPath in kitchenImages) {
        formData.files.add(
          MapEntry(
            "kitchenImages",
            await MultipartFile.fromFile(
              imgPath,
              filename: imgPath.split('/').last,
            ),
          ),
        );
      }

      final response = await NetworkCaller.multipartRequest(
        Urls.sellerRequest,
        formData: formData,
      );

      if (response.isSuccess) {
        // Save pending approval flag scoped to current user in LocalStorage
        final userId = await LocalStorage.getId();
        await LocalStorage.setPendingSellerApproval(userId, true);

        // Update SystempreferenceController: user cannot enter seller mode until admin approves
        if (Get.isRegistered<SystempreferenceController>()) {
          final prefController = Get.find<SystempreferenceController>();
          prefController.isRegisteredSeller.value = false;
          prefController.isSellerMode.value = false;
          prefController.hasPendingSellerRequest.value = true;
          prefController.fetchUserProfile();
        }

        // Show Admin Approval Dialog popup directly as requested
        AdminApprovalDialog.show(
          title: 'Application Submitted!',
          message:
              'Your seller registration has been submitted successfully. Please wait for Admin approval. Once the admin reviews and approves your account, you will be able to access the seller dashboard.',
          onDismiss: () {
            Get.back(); // dismiss popup
            Get.until((route) => route.settings.name == Routes.navbar);
          },
        );
      } else {
        Get.snackbar(
          'Submission Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to submit seller request. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Submission Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
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
