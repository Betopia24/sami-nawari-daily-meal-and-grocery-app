import 'package:get/get.dart';
import '../controllers/placeorder_controller.dart';

class PlaceorderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaceorderController>(
      () => PlaceorderController(),
    );
  }
}
