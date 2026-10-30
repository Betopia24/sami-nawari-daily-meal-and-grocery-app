import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/network/local_storage.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../systempreference/controllers/systempreference_controller.dart';

class DietaryPrefModel {
  final String id;
  final String title;
  final String subtitle;
  final String? imagePath;
  final String? textEmoji;

  DietaryPrefModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imagePath,
    this.textEmoji,
  });
}

class DietaryprefController extends GetxController {
  final searchText = ''.obs;

  // Storing selected preference IDs. Multiple selections allowed.
  final selectedPreferences = <String>{'no_preference'}.obs;
  final isSaving = false.obs;

  final List<DietaryPrefModel> allPreferences = [
    DietaryPrefModel(
      id: 'no_preference',
      title: 'No Preference',
      subtitle: 'Eat everything',
      imagePath: AppAssets.noPreferenceEmojiIcon,
    ),
    DietaryPrefModel(
      id: 'vegetarian',
      title: 'Vegetarian',
      subtitle: 'No meat or seafood',
      imagePath: AppAssets.saladEmojiIcon, // closest matching image
    ),
    DietaryPrefModel(
      id: 'vegan',
      title: 'Vegan',
      subtitle: 'No animal products',
      imagePath: AppAssets.veganEmojiIcon,
    ),
    DietaryPrefModel(
      id: 'halal',
      title: 'Halal',
      subtitle: 'Halal Food Only',
      imagePath: AppAssets.halalEmojiIcon,
    ),
    DietaryPrefModel(
      id: 'keto',
      title: 'Keto',
      subtitle: 'High fat, very low carb',
      imagePath: AppAssets.ketoEmojiIcon,
    ),
    DietaryPrefModel(
      id: 'mediterranean',
      title: 'Mediterranean',
      subtitle: 'Olive oil, fish, vegetables',
      imagePath: AppAssets.mediterraneanEmojiIcon,
    ),
    DietaryPrefModel(
      id: 'paleo',
      title: 'Paleo',
      subtitle: 'Whole, unprocessed foods',
      textEmoji: '🦴',
    ),
    DietaryPrefModel(
      id: 'low_carb',
      title: 'Low Carb',
      subtitle: 'Under 100g carbs daily',
      imagePath: AppAssets.lowCarbEmojiIcon,
    ),
    DietaryPrefModel(
      id: 'high_protein',
      title: 'High Protein',
      subtitle: 'Protein focused meals',
      imagePath: AppAssets.highProteinEmojiIcon,
    ),
    DietaryPrefModel(
      id: 'low_sugar',
      title: 'Low Sugar',
      subtitle: 'Minimal added sugar',
      textEmoji: '🚫',
    ),
    DietaryPrefModel(
      id: 'gluten_free',
      title: 'Gluten Free',
      subtitle: 'No wheat, barley, rye',
      imagePath: AppAssets.glutenFreeEmojiIcon,
    ),
    DietaryPrefModel(
      id: 'pescatarian',
      title: 'Pescatarian',
      subtitle: 'Vegetarian And Seafood',
      textEmoji: '🐟',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    loadCurrentPreferences();
  }

  Future<void> loadCurrentPreferences() async {
    try {
      List<dynamic> currentList = [];
      if (Get.isRegistered<SystempreferenceController>()) {
        final user = Get.find<SystempreferenceController>().user.value;
        if (user != null && user.dietaryPreferences.isNotEmpty) {
          currentList = user.dietaryPreferences;
        }
      }

      if (currentList.isEmpty) {
        final cached = await LocalStorage.getUser();
        if (cached != null && cached['dietaryPreferences'] is List) {
          currentList = cached['dietaryPreferences'];
        }
      }

      if (currentList.isNotEmpty) {
        selectedPreferences.clear();
        for (final item in currentList) {
          final itemStr = item.toString().trim().toLowerCase();
          final match = allPreferences.firstWhereOrNull(
            (p) =>
                p.id.toLowerCase() == itemStr ||
                p.title.toLowerCase() == itemStr ||
                p.id.replaceAll('_', '').toLowerCase() ==
                    itemStr.replaceAll(' ', '').toLowerCase(),
          );
          if (match != null && match.id != 'no_preference') {
            selectedPreferences.add(match.id);
          }
        }
        if (selectedPreferences.isEmpty) {
          selectedPreferences.add('no_preference');
        }
      } else {
        selectedPreferences.clear();
        selectedPreferences.add('no_preference');
      }
    } catch (e) {
      debugPrint('Error loading dietary preferences: $e');
    }
  }

  List<DietaryPrefModel> get filteredPreferences {
    if (searchText.value.isEmpty) {
      return allPreferences;
    }
    return allPreferences
        .where(
          (pref) =>
              pref.title.toLowerCase().contains(searchText.value.toLowerCase()),
        )
        .toList();
  }

  void togglePreference(String id) {
    if (id == 'no_preference') {
      // If selecting "no preference", clear everything else
      selectedPreferences.clear();
      selectedPreferences.add(id);
    } else {
      // If selecting a specific preference, remove "no preference"
      selectedPreferences.remove('no_preference');
      if (selectedPreferences.contains(id)) {
        selectedPreferences.remove(id);
      } else {
        selectedPreferences.add(id);
      }

      // If unselected everything, revert to "no preference"
      if (selectedPreferences.isEmpty) {
        selectedPreferences.add('no_preference');
      }
    }
  }

  Future<void> savePreferences() async {
    if (isSaving.value) return;
    isSaving.value = true;

    // Build the list of preference titles to send
    final List<String> listToSend = [];
    if (!selectedPreferences.contains('no_preference')) {
      for (final pref in allPreferences) {
        if (pref.id != 'no_preference' && selectedPreferences.contains(pref.id)) {
          listToSend.add(pref.title);
        }
      }
    }

    final body = {
      'dietaryPreferences': listToSend,
    };

    debugPrint('====================================================');
    debugPrint('[PATCH ${Urls.profileDietaryPreferences}] INITIATING REQUEST');
    debugPrint('URL: ${Urls.baseUrl}${Urls.profileDietaryPreferences}');
    debugPrint('Payload: $body');

    try {
      final response = await NetworkCaller.patchRequest(
        Urls.profileDietaryPreferences,
        body: body,
      );

      debugPrint('====================================================');
      debugPrint(
        '[PATCH ${Urls.profileDietaryPreferences}] StatusCode: ${response.statusCode}, isSuccess: ${response.isSuccess}',
      );
      debugPrint(
        '[PATCH ${Urls.profileDietaryPreferences}] Response: ${response.responseData}',
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
              'Dietary preferences updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        final errorMsg = response.responseData?['message']?.toString() ??
            (response.errorMessage.isNotEmpty
                ? response.errorMessage
                : 'Failed to update dietary preferences');
        debugPrint('[PATCH ${Urls.profileDietaryPreferences}] Error: $errorMsg');
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
      debugPrint('Error updating dietary preferences: $e');
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
}
