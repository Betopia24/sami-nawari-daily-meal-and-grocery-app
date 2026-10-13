import 'package:get/get.dart';

import '../../../../data/models/nutrition_instruction_model.dart';

class NutritioninstructionsController extends GetxController {
  late final NutritionInstructionModel instruction;

  @override
  void onInit() {
    super.onInit();
    // Get the instruction passed from the previous route
    if (Get.arguments is NutritionInstructionModel) {
      instruction = Get.arguments as NutritionInstructionModel;
    } else {
      // Fallback just in case
      instruction = NutritionInstructionModel.getInstructionForGoal('Weight Loss');
    }
  }
}
