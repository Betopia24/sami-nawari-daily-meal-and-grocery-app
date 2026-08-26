import 'package:get/get.dart';

import '../controllers/requestsent_controller.dart';

class RequestsentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestsentController>(
      () => RequestsentController(),
    );
  }
}
