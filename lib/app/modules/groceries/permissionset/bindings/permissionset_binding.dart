import 'package:get/get.dart';
import '../controllers/permissionset_controller.dart';

class PermissionSetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionSetController>(
      () => PermissionSetController(),
    );
  }
}
