import 'package:get/get.dart';
import '../controllers/welcomeauth_controller.dart';

class WelcomeauthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeauthController>(() => WelcomeauthController());
  }
}
