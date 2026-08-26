import 'package:get/get.dart';

import '../controllers/reviewbankdetails_controller.dart';

class ReviewbankdetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewbankdetailsController>(
      () => ReviewbankdetailsController(),
    );
  }
}
