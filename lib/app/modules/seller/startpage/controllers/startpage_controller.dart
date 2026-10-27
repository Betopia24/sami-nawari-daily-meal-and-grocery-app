import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../../../data/network/local_storage.dart';
import '../../widgets/admin_approval_dialog.dart';
import '../../../userprofile/systempreference/controllers/systempreference_controller.dart';

class StartpageController extends GetxController {
  Future<void> startRegistration() async {
    final userId = await LocalStorage.getId();
    final isPending = await LocalStorage.isPendingSellerApproval(userId);
    if (isPending) {
      if (Get.isRegistered<SystempreferenceController>()) {
        Get.find<SystempreferenceController>().showPendingApprovalDialog();
      } else {
        AdminApprovalDialog.show();
      }
      return;
    }
    Get.toNamed(Routes.SELLERREGISTRATION);
  }
}

