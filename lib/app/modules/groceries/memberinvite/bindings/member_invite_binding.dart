import 'package:get/get.dart';
import '../controllers/member_invite_controller.dart';

class MemberInviteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MemberInviteController>(
      () => MemberInviteController(),
    );
  }
}
