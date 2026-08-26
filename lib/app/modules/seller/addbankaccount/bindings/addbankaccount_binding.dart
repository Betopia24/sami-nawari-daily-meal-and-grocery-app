import 'package:get/get.dart';

import '../controllers/addbankaccount_controller.dart';

class AddbankaccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddbankaccountController>(
      () => AddbankaccountController(),
    );
  }
}
