import 'package:get/get.dart';

class AddbankaccountController extends GetxController {
  final currentStep = 1.obs;

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    } else {
      Get.toNamed('/reviewbankdetails');
    }
  }
}
