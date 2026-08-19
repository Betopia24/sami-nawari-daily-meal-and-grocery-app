import 'package:get/get.dart';
import '../../../../../routes/app_routes.dart';

class WelcomeauthController extends GetxController {
  // Add logic for routing to Sign In, Create Account, or Guest
  void onSignIn() {
    // Navigate to Sign In
  }

  void onCreateAccount() {
    Get.toNamed(Routes.signup);
  }

  void onContinueAsGuest() {
    // Continue as guest
  }
}
