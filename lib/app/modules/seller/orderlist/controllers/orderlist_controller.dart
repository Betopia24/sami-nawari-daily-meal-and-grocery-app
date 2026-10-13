import 'package:get/get.dart';

class OrderlistController extends GetxController {
  final selectedFilter = 'All'.obs;

  final List<String> filters = [
    'All',
    'New (1)',
    'Preparing',
    'Out for Delivery',
    'Delivered'
  ];

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
