import 'package:get/get.dart';

class SystempreferenceController extends GetxController {
  final notificationsEnabled = true.obs;

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }
}
