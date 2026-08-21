import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void saveAllergies() {
    Get.back();
  }

  @override
  void onClose() {
    customNameController.dispose();
    customEmojiController.dispose();
    super.onClose();
  }
}
