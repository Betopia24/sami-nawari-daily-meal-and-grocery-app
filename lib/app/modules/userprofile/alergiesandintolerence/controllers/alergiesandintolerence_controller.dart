import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/network/local_storage.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../systempreference/controllers/systempreference_controller.dart';

class AllergyModel {
  final String id;
  final String title;
  final String emoji;
  final String severity;

  AllergyModel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.severity,
  });
}

class AlergiesandintolerenceController extends GetxController {
  final selectedAllergies = <String>{}.obs;
  final isSaving = false.obs;

  final customNameController = TextEditingController();
  final customEmojiController = TextEditingController();
  final customSeverity = 'Common'.obs;

  final allAllergies = <AllergyModel>[
    AllergyModel(
      id: 'milk_dairy',
      title: 'Milk & Dairy',
      emoji: '🥛',
      severity: 'Common',
    ),
    AllergyModel(id: 'eggs', title: 'Eggs', emoji: '🥚', severity: 'Common'),
    AllergyModel(id: 'fish', title: 'Fish', emoji: '🐟', severity: 'Common'),
    AllergyModel(
      id: 'seafood',
      title: 'Seafood',
      emoji: '🦞',
      severity: 'Common',
    ),
    AllergyModel(
      id: 'shellfish',
      title: 'Shellfish',
      emoji: '🦪',
      severity: 'Common',
    ),
    AllergyModel(
      id: 'peanuts',
      title: 'Peanuts',
      emoji: '🥜',
      severity: 'Severe',
    ),
    AllergyModel(
      id: 'tree_nuts',
      title: 'Tree Nuts',
      emoji: '🌰',
      severity: 'Severe',
    ),
    AllergyModel(id: 'soy', title: 'Soy', emoji: '🫘', severity: 'Common'),
    AllergyModel(
      id: 'sesame',
      title: 'Sesame',
      emoji: '🌾',
      severity: 'Common',
    ),
    AllergyModel(id: 'wheat', title: 'Wheat', emoji: '🍞', severity: 'Common'),
    AllergyModel(
      id: 'gluten',
      title: 'Gluten',
      emoji: '🥐',
      severity: 'Common',
    ),
    AllergyModel(id: 'corn', title: 'Corn', emoji: '🌽', severity: 'Moderate'),
    AllergyModel(
      id: 'mustard',
      title: 'Mustard',
      emoji: '🌻',
      severity: 'Moderate',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentAllergies();
  }

  Future<void> loadCurrentAllergies() async {
    try {
      List<dynamic> currentList = [];
      if (Get.isRegistered<SystempreferenceController>()) {
        final user = Get.find<SystempreferenceController>().user.value;
        if (user != null && user.allergies.isNotEmpty) {
          currentList = user.allergies;
        }
      }

      if (currentList.isEmpty) {
        final cached = await LocalStorage.getUser();
        if (cached != null && cached['allergies'] is List) {
          currentList = cached['allergies'];
        }
      }

      if (currentList.isNotEmpty) {
        selectedAllergies.clear();
        for (final item in currentList) {
          final itemStr = item.toString().trim();
          final match = allAllergies.firstWhereOrNull(
            (a) =>
                a.id.toLowerCase() == itemStr.toLowerCase() ||
                a.title.toLowerCase() == itemStr.toLowerCase() ||
                a.id.replaceAll('_', '').toLowerCase() ==
                    itemStr.replaceAll(' ', '').toLowerCase(),
          );
          if (match != null) {
            selectedAllergies.add(match.id);
          } else {
            // It might be a custom allergen that was previously saved
            final customId =
                'custom_${itemStr.toLowerCase().replaceAll(' ', '_')}';
            allAllergies.add(
              AllergyModel(
                id: customId,
                title: itemStr,
                emoji: '⚠️',
                severity: 'Common',
              ),
            );
            selectedAllergies.add(customId);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading allergies: $e');
    }
  }

  void toggleAllergy(String id) {
    if (selectedAllergies.contains(id)) {
      selectedAllergies.remove(id);
    } else {
      selectedAllergies.add(id);
    }
  }

  void addCustomAllergen() {
    if (customNameController.text.trim().isEmpty ||
        customEmojiController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a name and emoji',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    final newId = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    allAllergies.add(
      AllergyModel(
        id: newId,
        title: customNameController.text.trim(),
        emoji: customEmojiController.text.trim(),
        severity: customSeverity.value,
      ),
    );

    selectedAllergies.add(newId);

    customNameController.clear();
    customEmojiController.clear();
    customSeverity.value = 'Common';

    Get.back();
  }

  Future<void> saveAllergies() async {
    if (isSaving.value) return;
    isSaving.value = true;

    // Build the list of allergy titles to send
    final List<String> listToSend = [];
    for (final allergy in allAllergies) {
      if (selectedAllergies.contains(allergy.id)) {
        listToSend.add(allergy.title);
      }
    }

    final body = {
      'allergies': listToSend,
    };

    debugPrint('====================================================');
    debugPrint('[PATCH ${Urls.profileAlergies}] INITIATING REQUEST');
    debugPrint('URL: ${Urls.baseUrl}${Urls.profileAlergies}');
    debugPrint('Payload: $body');

    try {
      final response = await NetworkCaller.patchRequest(
        Urls.profileAlergies,
        body: body,
      );

      debugPrint('====================================================');
      debugPrint(
        '[PATCH ${Urls.profileAlergies}] StatusCode: ${response.statusCode}, isSuccess: ${response.isSuccess}',
      );
      debugPrint(
        '[PATCH ${Urls.profileAlergies}] Response: ${response.responseData}',
      );

      if (response.isSuccess) {
        if (response.responseData != null &&
            response.responseData['data'] != null) {
          final data = response.responseData['data'];
          if (data is Map<String, dynamic>) {
            await LocalStorage.saveUser(data);
            if (Get.isRegistered<SystempreferenceController>()) {
              final sysController = Get.find<SystempreferenceController>();
              sysController.user.value = UserModel.fromJson(data);
            }
          }
        }

        if (Get.isRegistered<SystempreferenceController>()) {
          Get.find<SystempreferenceController>().fetchUserProfile();
        }

        // Navigate back immediately
        Get.back();

        Get.snackbar(
          'Success',
          response.responseData?['message']?.toString() ??
              'Allergies and intolerances updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        final errorMsg = response.responseData?['message']?.toString() ??
            (response.errorMessage.isNotEmpty
                ? response.errorMessage
                : 'Failed to update allergies and intolerances');
        debugPrint('[PATCH ${Urls.profileAlergies}] Error: $errorMsg');
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint('Error updating allergies: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    customNameController.dispose();
    customEmojiController.dispose();
    super.onClose();
  }
}
