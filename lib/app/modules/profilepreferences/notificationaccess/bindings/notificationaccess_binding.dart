import 'package:get/get.dart';
import '../controllers/notificationaccess_controller.dart';

class NotificationaccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationaccessController>(
      () => NotificationaccessController(),
    );
  }
}
