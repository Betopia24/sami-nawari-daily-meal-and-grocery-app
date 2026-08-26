import 'package:get/get.dart';

class TransactionModel {
  final String id;
  final String amount;
  final String date;
  final String time;
  final String type;
  final bool isPositive;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.time,
    required this.type,
    required this.isPositive,
  });
}

class EarninghistoryController extends GetxController {
  final selectedFilter = 'All'.obs;
  final selectedMonth = 'This month'.obs;

  final List<String> filters = ['All', 'Orders', 'Withdraw'];
  final List<String> months = [
    'This month',
    'Last month',
    'Last 3 months',
    'This year'
  ];

  final List<TransactionModel> transactions = [
    TransactionModel(
      id: '#DM-2026-1011',
      amount: '+\$12.99',
      date: 'Aug 30',
      time: '1:00 PM',
      type: 'Online Paid',
      isPositive: true,
    ),
    TransactionModel(
      id: '#DM-2026-1010',
      amount: '+\$45.50',
      date: 'Aug 30',
      time: '12:30 PM',
      type: 'Online Paid',
      isPositive: true,
    ),
    TransactionModel(
      id: '#DM-2026-1009',
      amount: '+\$23.50',
      date: 'Aug 29',
      time: '07:30 PM',
      type: 'Cash on Delivery',
      isPositive: true,
    ),
    TransactionModel(
      id: 'Withdraw to Bank',
      amount: '-\$150.00',
      date: 'Aug 25',
      time: '10:30 AM',
      type: 'Withdraw',
      isPositive: false,
    ),
    TransactionModel(
      id: '#DM-2026-1008',
      amount: '+\$6.50',
      date: 'Aug 25',
      time: '08:30 AM',
      type: 'Cash on Pickup',
      isPositive: true,
    ),
  ];

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }
}
