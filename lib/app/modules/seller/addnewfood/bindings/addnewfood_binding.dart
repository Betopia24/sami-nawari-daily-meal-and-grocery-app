import 'package:get/get.dart';
import '../controllers/addnewfood_controller.dart';

class AddnewfoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddnewfoodController>(
      () => AddnewfoodController(),
    );
  }
}
