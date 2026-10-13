import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditbuyerprofileController extends GetxController {
  final fullNameController = TextEditingController(text: 'Rafiul Islam');
  final usernameController = TextEditingController(text: '@ rafi');
  final bioController = TextEditingController();
  final emailController = TextEditingController(text: 'rafi@gmail.com');
  final phoneController = TextEditingController(text: '+1 (555) 000-1234');
  final birthdayController = TextEditingController(text: '04/15/1990');
  final addressController = TextEditingController(
    text: '123 Market St, San Francisco, CA',
  );

  final RxString selectedGender = 'Male'.obs;
  final Rx<String?> profileImagePath = Rx<String?>(null);

  final ImagePicker _picker = ImagePicker();

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

  void saveChanges() {
    // Implement save logic here
    Get.back();
  }
}
