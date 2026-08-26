import 'package:get/get.dart';
import '../controllers/editsellerprofile_controller.dart';

class EditsellerprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditsellerprofileController>(
      () => EditsellerprofileController(),
    );
  }
}
