import 'package:get/get.dart';
import '../../widgets/order_card.dart';

class OrderModel {
  final String title;
  final String restaurantName;
  final String timeAgo;
  final double price;
  final OrderStatus status;
  final OrderType type;

  OrderModel({
    required this.title,
    required this.restaurantName,
    required this.timeAgo,
    required this.price,
    required this.status,
    required this.type,
  });
}

class OrderhistoryController extends GetxController {
  final selectedTabIndex = 0.obs;

  final List<String> tabOptions = ['All', 'Active', 'Completed'];

  // Mock data for the orders list
  final List<OrderModel> allOrders = [
    OrderModel(
      title: 'Classic Mezze Platter',
      restaurantName: "Maria's Kitchen",
      timeAgo: '2 days ago',
      price: 20.50,
      status: OrderStatus.delivered,
      type: OrderType.delivery,
    ),
    OrderModel(
      title: 'Cacio e Pepe',
      restaurantName: "Luca's Pasta Club",
      timeAgo: '1 week ago',
      price: 15.00,
      status: OrderStatus.pickedUp,
      type: OrderType.pickup,
    ),
    OrderModel(
      title: 'Cacio e Pepe',
      restaurantName: "Chen's Dim Sum",
      timeAgo: '20 min ago',
      price: 22.00,
      status: OrderStatus.preparing,
      type: OrderType.delivery,
    ),
  ];

  List<OrderModel> get filteredOrders {
    switch (selectedTabIndex.value) {
      case 1: // Active
        return allOrders
            .where((order) => order.status == OrderStatus.preparing)
            .toList();
      case 2: // Completed
        return allOrders
            .where(
              (order) =>
                  order.status == OrderStatus.delivered ||
                  order.status == OrderStatus.pickedUp,
            )
            .toList();
      case 0: // All
      default:
        return allOrders;
    }
  }

  void onTabChanged(int index) {
    selectedTabIndex.value = index;
  }
}
