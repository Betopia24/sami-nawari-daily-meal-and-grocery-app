import 'package:get/get.dart';
import '../controllers/editbuyerprofile_controller.dart';

class EditbuyerprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditbuyerprofileController>(() => EditbuyerprofileController());
  }
}
