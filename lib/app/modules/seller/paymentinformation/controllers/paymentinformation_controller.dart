import 'package:get/get.dart';

class PaymentInformationController extends GetxController {
  // Add any observable state if needed, for example, the balance or lists of transactions.
  final balance = 120.50.obs;
  final totalEarnings = 240.50.obs;
  final totalWithdraws = 120.00.obs;

  // Mock data for withdraw history
  final withdrawHistory = [
    {
      'title': 'Withdraw to Bank',
      'date': 'Aug 30, 12:30 PM',
      'amount': '-\$150.00',
      'status': 'Completed',
    },
    {
      'title': 'Withdraw to Bank',
      'date': 'Aug 28, 10:30 PM',
      'amount': '-\$200.00',
      'status': 'Completed',
    },
    {
      'title': 'Withdraw to Bank',
      'date': 'Aug 25, 04:30 PM',
      'amount': '-\$100.00',
      'status': 'Processing',
    },
  ].obs;

  void onWithdrawRequest() {
    // Handle withdraw request
  }
}
