import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class EarningsController extends GetxController {
  final selectedMonth = 'This month'.obs;
  
  final List<String> months = ['This month', 'Last month', 'Last 3 months', 'This year'];

  // Mock data for the chart
  final totalEarnings = 240.50.obs;
  final earningsPercentage = 18.5.obs;
  
  final completedOrders = 32.obs;
  final completedOrdersPercentage = 12.3.obs;
  
  final pendingEarnings = 120.00.obs;
  final pendingOrdersCount = 2.obs;
  
  final availableBalance = 120.50.obs;

  List<FlSpot> get chartData => const [
    FlSpot(0, 0),
    FlSpot(2, 100),
    FlSpot(3, 100),
    FlSpot(4, 155),
    FlSpot(5, 200),
    FlSpot(6, 240.50),
  ];

  List<String> get bottomTitles => [
    'Aug 1', 
    'Aug 5', 
    'Aug 10', 
    'Aug 15', 
    'Aug 20', 
    'Aug 25', 
    'Aug 30'
  ];
}
