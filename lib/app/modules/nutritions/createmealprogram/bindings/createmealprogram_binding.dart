import 'package:get/get.dart';

import '../controllers/createmealprogram_controller.dart';

class CreatemealprogramBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatemealprogramController>(
      () => CreatemealprogramController(),
    );
  }
}
