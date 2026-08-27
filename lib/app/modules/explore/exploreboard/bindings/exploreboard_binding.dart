import 'package:get/get.dart';
import '../controllers/exploreboard_controller.dart';

class ExploreboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreboardController>(() => ExploreboardController());
  }
}
