import 'package:get/get.dart';

import '../controllers/addfooddetails_controller.dart';

class AddfooddetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddfooddetailsController>(
      () => AddfooddetailsController(),
    );
  }
}
