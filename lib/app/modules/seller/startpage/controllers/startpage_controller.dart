import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class StartpageController extends GetxController {
  void startRegistration() {
    Get.toNamed(Routes.SELLERREGISTRATION);
  }
}

