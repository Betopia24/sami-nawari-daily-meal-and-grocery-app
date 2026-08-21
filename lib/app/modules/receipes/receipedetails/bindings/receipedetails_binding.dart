import 'package:get/get.dart';
import '../controllers/receipedetails_controller.dart';

class ReceipedetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceipedetailsController>(() => ReceipedetailsController());
  }
}
