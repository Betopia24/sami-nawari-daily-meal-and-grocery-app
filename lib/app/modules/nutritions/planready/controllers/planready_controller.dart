import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class PlanreadyController extends GetxController {
  final goal = ''.obs;
  final mealPlanId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Retrieve goal from arguments if passed
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map<String, dynamic>;
      if (args.containsKey('goal')) {
        goal.value = args['goal'];
      }
      if (args.containsKey('mealPlanId')) {
        mealPlanId.value = args['mealPlanId']?.toString() ?? '';
      }
    }

    if (goal.value.isEmpty) {
      goal.value = 'Lose Weight'; // Fallback
    }
  }

  void onViewMealPlan() {
    Get.toNamed(
      Routes.mealplan,
      arguments: {
        if (mealPlanId.value.isNotEmpty) 'mealPlanId': mealPlanId.value,
      },
    );
  }

  void onGoHome() {
    Get.offAllNamed(Routes.dashboard);
  }
}
