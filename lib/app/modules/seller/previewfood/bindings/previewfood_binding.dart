import 'package:get/get.dart';

import '../controllers/previewfood_controller.dart';

class PreviewfoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreviewfoodController>(
      () => PreviewfoodController(),
    );
  }
}
