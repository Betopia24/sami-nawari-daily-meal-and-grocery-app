import 'package:get/get.dart';
import '../controllers/locationaccess_controller.dart';

class LocationaccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationaccessController>(() => LocationaccessController());
  }
}
