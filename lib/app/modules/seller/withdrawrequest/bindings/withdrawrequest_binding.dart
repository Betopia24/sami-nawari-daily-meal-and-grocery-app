import 'package:get/get.dart';

import '../controllers/withdrawrequest_controller.dart';

class WithdrawrequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawrequestController>(
      () => WithdrawrequestController(),
    );
  }
}
