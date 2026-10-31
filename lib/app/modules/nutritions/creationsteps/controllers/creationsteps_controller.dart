import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../nutritionboard/controllers/nutritionboard_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class CreationstepsController extends GetxController {
  final currentStep = 1.obs;
  final isGenerating = false.obs;

  // Step 1: Who is this for?
  final selectedPerson = ''.obs;

  // Step 2: About you
  final ageController = TextEditingController();
  final selectedGender = 'Male'.obs;
  final selectedActivity = ''.obs;

  // Step 3: Goal
  final selectedGoal = ''.obs;

  // Step 4: Meal Types
  final selectedMeals = <String>[].obs;

  final genderOptions = ['Male', 'Female', 'Other'];

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
    } else {
      _finishCreation();
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back(); // Go back to the previous screen if on step 1
    }
  }

  void setPerson(String person) {
    selectedPerson.value = person;
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void setActivity(String activity) {
    selectedActivity.value = activity;
  }

  void setGoal(String goal) {
    selectedGoal.value = goal;
  }

  void toggleMeal(String meal) {
    if (selectedMeals.contains(meal)) {
      selectedMeals.remove(meal);
    } else {
      selectedMeals.add(meal);
    }
  }

  Future<void> _finishCreation() async {
    isGenerating.value = true;
    String generatedMealPlanId = '';

    try {
      final now = DateTime.now();
      final formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final mealsList = selectedMeals.isNotEmpty
          ? selectedMeals.map((m) => m.toLowerCase()).toList()
          : ["breakfast", "lunch", "dinner"];

      final response = await NetworkCaller.postRequest(
        Urls.aiMealPlansGenerate,
        body: {
          "start_date": formattedDate,
          "days": 3,
          "meals_per_day": mealsList,
          "goal_override": selectedGoal.value.isNotEmpty ? selectedGoal.value : null,
          "excluded_recipe_ids": []
        },
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData['data'];
        if (data is Map) {
          generatedMealPlanId = data['generation_id']?.toString() ??
              data['plan_id']?.toString() ??
              data['id']?.toString() ??
              '';
        }
      }
    } catch (e) {
      debugPrint("Error generating meal plan in creation steps: $e");
    } finally {
      isGenerating.value = false;
    }

    // Attempt to update the nutrition board
    try {
      if (Get.isRegistered<NutritionboardController>()) {
        final nutritionBoardController = Get.find<NutritionboardController>();
        nutritionBoardController.hasMealPlan.value = true;
        if (generatedMealPlanId.isNotEmpty) {
          nutritionBoardController.activeMealPlanId.value = generatedMealPlanId;
        }
      }
    } catch (e) {
      debugPrint("Error updating nutrition board: $e");
    }
    
    // Navigate to the planready screen, passing the selected goal & mealPlanId
    Get.toNamed(Routes.planready, arguments: {
      'goal': selectedGoal.value.isNotEmpty ? selectedGoal.value : 'Lose Weight',
      if (generatedMealPlanId.isNotEmpty) 'mealPlanId': generatedMealPlanId,
    });
  }

  @override
  void onClose() {
    ageController.dispose();
    super.onClose();
  }
}
