import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/local_storage.dart';
import '../../../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _handleInitialNavigation();
  }

  void _handleInitialNavigation() async {
    await Future.delayed(const Duration(seconds: 2));

    // Check if user has an active, valid (non-expired) JWT access token
    final bool hasValidToken = await LocalStorage.isLoggedIn();

    if (hasValidToken) {
      Get.offAllNamed(Routes.navbar);
    } else {
      Get.offAllNamed(Routes.signin);
    }
  }
}
