import 'package:get/get.dart';

import '../controllers/paymentinformation_controller.dart';

class PaymentInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentInformationController>(
      () => PaymentInformationController(),
    );
  }
}
