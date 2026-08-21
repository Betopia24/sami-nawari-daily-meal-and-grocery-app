import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../routes/app_routes.dart';

class FoodpreferencesController extends GetxController {
  final RxSet<String> selectedPreferences = <String>{}.obs;

  final List<Map<String, String>> foodOptions = [
    {
      'id': 'vegetarian',
      'icon': AppAssets.weightLossIcon, // using 🥗 emoji string
      'title': 'Vegetarian',
      'subtitle': 'No meat or seafood',
    },
    {
      'id': 'vegan',
      'icon': AppAssets.veganEmojiIcon,
      'title': 'Vegan',
      'subtitle': 'No animal products',
    },
    {
      'id': 'halal',
      'icon': AppAssets.halalEmojiIcon,
      'title': 'Halal',
      'subtitle': 'Halal certified only',
    },
    {
      'id': 'keto',
      'icon': AppAssets.ketoEmojiIcon,
      'title': 'Keto',
      'subtitle': 'High fat, low carb',
    },
    {
      'id': 'gluten_free',
      'icon': AppAssets.glutenFreeEmojiIcon,
      'title': 'Gluten Free',
      'subtitle': 'No wheat or gluten',
    },
    {
      'id': 'high_protein',
      'icon': AppAssets.highProteinEmojiIcon,
      'title': 'High Protein',
      'subtitle': 'Protein-focused meals',
    },
    {
      'id': 'low_carb',
      'icon': AppAssets.lowCarbEmojiIcon,
      'title': 'Low Carb',
      'subtitle': 'Under 100g carbs/day',
    },
    {
      'id': 'mediterranean',
      'icon': AppAssets.mediterraneanEmojiIcon,
      'title': 'Mediterranean',
      'subtitle': 'Olive oil, fish, veg',
    },
    {
      'id': 'no_preference',
      'icon': AppAssets.noPreferenceEmojiIcon,
      'title': 'No Preference',
      'subtitle': 'I eat everything!',
    },
  ];

  void togglePreference(String id) {
    if (id == 'no_preference') {
      if (selectedPreferences.contains('no_preference')) {
        selectedPreferences.remove('no_preference');
      } else {
        selectedPreferences.clear();
        selectedPreferences.add('no_preference');
      }
      return;
    }

    if (selectedPreferences.contains('no_preference')) {
      selectedPreferences.remove('no_preference');
    }

    if (selectedPreferences.contains(id)) {
      selectedPreferences.remove(id);
    } else {
      selectedPreferences.add(id);
    }
  }

  void proceed() {
    if (selectedPreferences.isEmpty) {
      Get.snackbar(
        'Selection Required',
        'Please select at least one food preference to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    print('Selected preferences: ${selectedPreferences.toList()}');
    // Save to backend or local storage here
    Get.toNamed(Routes.questionprefs);
  }
}
