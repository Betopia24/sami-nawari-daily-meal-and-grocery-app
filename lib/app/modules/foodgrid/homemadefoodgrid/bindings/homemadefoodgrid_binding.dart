import 'package:get/get.dart';
import '../controllers/homemadefoodgrid_controller.dart';

class HomemadefoodgridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomemadefoodgridController>(() => HomemadefoodgridController());
  }
}
