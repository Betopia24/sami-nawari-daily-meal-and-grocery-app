import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

import '../../../../data/models/nutrition_instruction_model.dart';

class MealplanController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }

  void onContinue() {
    Get.toNamed(
      Routes.nutritioninstructions, 
      arguments: NutritionInstructionModel.getInstructionForGoal('Weight Loss'),
    );
  }
}
