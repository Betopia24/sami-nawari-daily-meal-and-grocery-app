import 'package:get/get.dart';

class NotificationController extends GetxController {
  final selectedFilter = 'All'.obs;

  final filters = [
    'All',
    'Unread (3)',
    'Meal',
    'Grocery',
    'Order',
    'Recipe',
  ];

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}

