import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../nutritionboard/controllers/nutritionboard_controller.dart';
import '../../../../routes/app_routes.dart';

class CreationstepsController extends GetxController {
  final currentStep = 1.obs;

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

  void _finishCreation() {
    // Attempt to update the nutrition board
    try {
      if (Get.isRegistered<NutritionboardController>()) {
        final nutritionBoardController = Get.find<NutritionboardController>();
        nutritionBoardController.hasMealPlan.value = true;
      }
    } catch (e) {
      debugPrint("Error updating nutrition board: $e");
    }
    
    // Navigate to the planready screen, passing the selected goal
    Get.toNamed(Routes.planready, arguments: {
      'goal': selectedGoal.value.isNotEmpty ? selectedGoal.value : 'Lose Weight'
    });
  }

  @override
  void onClose() {
    ageController.dispose();
    super.onClose();
  }
}
