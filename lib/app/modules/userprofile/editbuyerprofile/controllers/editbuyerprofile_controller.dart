import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/network/local_storage.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../systempreference/controllers/systempreference_controller.dart';

class EditbuyerprofileController extends GetxController {
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdayController = TextEditingController();
  final addressController = TextEditingController();

  final RxString selectedGender = 'Male'.obs;
  final Rx<String?> profileImagePath = Rx<String?>(null);
  final Rx<String?> networkProfileImageUrl = Rx<String?>(null);
  final RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // 1. Load cached user first
    final cached = await LocalStorage.getUser();
    if (cached != null) {
      _applyUserData(cached);
    }

    // 2. Fetch fresh user data from server
    try {
      final response = await NetworkCaller.getRequest(Urls.userMe);
      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData['data'];
        if (data is Map<String, dynamic>) {
          await LocalStorage.saveUser(data);
          _applyUserData(data);
        }
      }
    } catch (e) {
      debugPrint('Error loading user profile in EditbuyerprofileController: $e');
    }
  }

  void _applyUserData(Map<String, dynamic> data) {
    if (data['name'] != null && fullNameController.text.isEmpty) {
      fullNameController.text = data['name'].toString();
    }
    if (data['username'] != null && usernameController.text.isEmpty) {
      usernameController.text = data['username'].toString();
    }
    if (data['email'] != null && emailController.text.isEmpty) {
      emailController.text = data['email'].toString();
    }
    if (data['phone'] != null && phoneController.text.isEmpty) {
      phoneController.text = data['phone'].toString();
    }
    if (data['bio'] != null && bioController.text.isEmpty) {
      bioController.text = data['bio'].toString();
    }
    if (data['birthday'] != null && birthdayController.text.isEmpty) {
      birthdayController.text = data['birthday'].toString();
    }
    if (data['address'] != null && addressController.text.isEmpty) {
      addressController.text = data['address'].toString();
    }
    if (data['gender'] != null) {
      selectedGender.value = data['gender'].toString();
    }
    if (data['profilePicture'] != null &&
        data['profilePicture'].toString().isNotEmpty) {
      networkProfileImageUrl.value = data['profilePicture'].toString();
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    addressController.dispose();
    super.onClose();
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        profileImagePath.value = image.path;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> saveChanges() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        'name': fullNameController.text.trim(),
        'username': usernameController.text.trim(),
        'phone': phoneController.text.trim(),
        'bio': bioController.text.trim(),
        'birthday': birthdayController.text.trim(),
        'address': addressController.text.trim(),
        'gender': selectedGender.value,
      };

      final response = await NetworkCaller.patchRequest(
        Urls.updateProfile,
        body: body,
      );

      isLoading.value = false;

      if (response.isSuccess) {
        // Also update cached user
        final cached = await LocalStorage.getUser() ?? {};
        cached.addAll(body);
        await LocalStorage.saveUser(cached);

        // Refresh SystempreferenceController if active
        if (Get.isRegistered<SystempreferenceController>()) {
          Get.find<SystempreferenceController>().fetchUserProfile();
        }

        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } else {
        // If API fails or endpoint not ready, still save locally and go back
        final cached = await LocalStorage.getUser() ?? {};
        cached.addAll(body);
        await LocalStorage.saveUser(cached);

        if (Get.isRegistered<SystempreferenceController>()) {
          Get.find<SystempreferenceController>().user.value =
              UserModel.fromJson(cached);
        }

        Get.back();
        Get.snackbar(
          'Saved',
          'Profile changes saved locally',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.back();
    }
  }
}

