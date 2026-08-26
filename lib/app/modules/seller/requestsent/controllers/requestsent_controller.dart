import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';

class RequestsentController extends GetxController {
  void viewWithdrawHistory() {
    // Replace requestsent with earninghistory so back button works normally
    Get.offNamed(Routes.earninghistory);
  }

  void backToPaymentInformation() {
    Get.offNamed(Routes.paymentinformation);
  }
}
