import 'package:get/get.dart';

class OrderdetailsController extends GetxController {
  final status = 'New'.obs;

  final List<String> filters = [
    'All',
    'New (1)',
    'Preparing',
    'Out for Delivery',
    'Delivered'
  ];
  final selectedFilter = 'New (1)'.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map && args['status'] != null) {
      status.value = args['status'];
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void updateStatus(String newStatus) {
    status.value = newStatus;
  }

  void acceptOrder() {
    status.value = 'Accepted';
  }

  void declineOrder() {
    // Handle decline
    Get.back();
  }
}
