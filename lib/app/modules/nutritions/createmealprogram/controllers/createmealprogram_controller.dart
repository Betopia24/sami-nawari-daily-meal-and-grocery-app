import 'package:get/get.dart';
import '../../nutritionboard/controllers/nutritionboard_controller.dart';
import '../../../../routes/app_routes.dart';

class CreatemealprogramController extends GetxController {
  
  void onGetStarted() {
    Get.toNamed(Routes.creationsteps);
  }
}
