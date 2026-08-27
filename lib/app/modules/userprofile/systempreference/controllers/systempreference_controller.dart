import 'package:get/get.dart';

class SystempreferenceController extends GetxController {
  final notificationsEnabled = true.obs;

  final isSellerMode = false.obs; // TODO: Change back to false after development
  final isRegisteredSeller = false.obs; // TODO: Change back to false after development

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  void toggleSellerMode() {
    isSellerMode.value = !isSellerMode.value;
  }
}
