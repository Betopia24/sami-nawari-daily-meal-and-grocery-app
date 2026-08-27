import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class PlanreadyController extends GetxController {
  final goal = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Retrieve goal from arguments if passed
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map<String, dynamic>;
      if (args.containsKey('goal')) {
        goal.value = args['goal'];
      }
    }

    if (goal.value.isEmpty) {
      goal.value = 'Lose Weight'; // Fallback
    }
  }

  void onViewMealPlan() {
    Get.toNamed(Routes.mealplan);
  }

  void onGoHome() {
    Get.offAllNamed(Routes.dashboard);
  }
}
