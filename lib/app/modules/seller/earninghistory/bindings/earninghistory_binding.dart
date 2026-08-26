import 'package:get/get.dart';

import '../controllers/earninghistory_controller.dart';

class EarninghistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EarninghistoryController>(
      () => EarninghistoryController(),
    );
  }
}
