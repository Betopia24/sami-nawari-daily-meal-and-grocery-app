import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class LocationaccessController extends GetxController {
  void allowLocation() {
    // Implement location permission request logic here
    print("Requesting location permission...");
    // After requesting, navigate to the notification access screen
    Get.toNamed(Routes.notificationaccess);
  }

  void skip() {
    print("Skipping location permission...");
    Get.toNamed(Routes.notificationaccess);
  }
}
