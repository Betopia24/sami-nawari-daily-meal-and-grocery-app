import 'package:get/get.dart';
import '../controllers/shared_members_controller.dart';

class SharedMembersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedMembersController>(
      () => SharedMembersController(),
    );
  }
}
