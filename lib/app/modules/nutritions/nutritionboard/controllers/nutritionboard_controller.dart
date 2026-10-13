import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../../../data/models/nutrition_instruction_model.dart';

class NutritionboardController extends GetxController {
  // Goal category data
  final List<Map<String, dynamic>> goalCategories = [
    {
      'emoji': '🥗',
      'title': 'Weight Loss',
      'subtitle': 'Sustainable, not drastic',
    },
    {
      'emoji': '🥪',
      'title': 'Weight Gain',
      'subtitle': "Build, don't just eat more",
    },
    {
      'emoji': '🧒',
      'title': 'Foods for Children',
      'subtitle': 'Build strong foundation',
    },
    {
      'emoji': '🤱',
      'title': 'Foods for Mothers',
      'subtitle': 'Nourish yourself, nourish your child',
    },
    {
      'emoji': '🧑',
      'title': 'Food for Teenagers',
      'subtitle': 'Energy for Growth spurts',
    },
    {
      'emoji': '🎯',
      'title': 'Healthy Lifestyle',
      'subtitle': 'Balance is the foundation',
    },
  ];

  // Whether user has an active meal plan
  final RxBool hasMealPlan = false.obs;

  void onGoalTapped(String title) {
    // Determine title to use for lookup since it says 'Foods for Mothers' here instead of 'Foods for Mother'
    String lookupTitle = title;
    if (title == 'Foods for Mothers') lookupTitle = 'Foods for Mother';

    final instruction = NutritionInstructionModel.getInstructionForGoal(
      lookupTitle,
    );
    Get.toNamed(Routes.nutritioninstructions, arguments: instruction);
  }

  void onCreateMealPlan() {
    Get.toNamed(Routes.createmealprogram);
  }

  void onViewTodaysPlan() {
    // Navigate to today's plan
  }
}
