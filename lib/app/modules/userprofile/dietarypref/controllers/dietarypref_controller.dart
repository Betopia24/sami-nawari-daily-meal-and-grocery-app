import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';

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

  void savePreferences() {
    Get.back();
  }
}
