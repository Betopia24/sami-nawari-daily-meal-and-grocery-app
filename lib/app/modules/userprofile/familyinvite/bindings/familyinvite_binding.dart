import 'package:get/get.dart';
import '../controllers/familyinvite_controller.dart';

class FamilyinviteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyinviteController>(() => FamilyinviteController());
  }
}
