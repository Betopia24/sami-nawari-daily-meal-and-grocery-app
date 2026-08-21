import 'package:get/get.dart';
import '../controllers/termandcondition_controller.dart';

class TermandconditionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermandconditionController>(() => TermandconditionController());
  }
}
