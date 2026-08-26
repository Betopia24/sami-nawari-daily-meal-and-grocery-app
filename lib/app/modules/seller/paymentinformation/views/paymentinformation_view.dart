import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/paymentinformation_controller.dart';
import '../widgets/available_balance_card.dart';
import '../widgets/bank_account_card.dart';
import '../widgets/dashed_add_button.dart';
import '../widgets/payment_stat_card.dart';
import '../widgets/withdraw_history_card.dart';

class PaymentInformationView extends GetView<PaymentInformationController> {
  const PaymentInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: CustomBackButton(
            onTap: () => Get.offNamed(Routes.systempreference),
          ),
        ),
        title: Text(
          'Payment Information',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        titleSpacing: 12,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Available Balance
              Obx(() => AvailableBalanceCard(
                    balance: controller.balance.value.toStringAsFixed(2),
                    onWithdrawRequest: controller.onWithdrawRequest,
                  )),
              const SizedBox(height: 16),

              // Stats Row
              Row(
                children: [
                  Obx(() => PaymentStatCard(
                        iconPath: AppAssets.totalearningIcon,
                        amount: '\$${controller.totalEarnings.value.toStringAsFixed(2)}',
                        title: 'Total Earnings',
                      )),
                  Obx(() => PaymentStatCard(
                        iconPath: AppAssets.withdrawIcon, // using withdraw icon
                        amount: '\$${controller.totalWithdraws.value.toStringAsFixed(2)}',
                        title: 'Total Withdraws',
                      )),
                  Obx(() => PaymentStatCard(
                        iconPath: AppAssets.availablebalanceIcon,
                        amount: '\$${controller.balance.value.toStringAsFixed(2)}',
                        title: 'Available Balance',
                      )),
                ],
              ),
              const SizedBox(height: 24),

              // Payment Methods
              Text(
                'Payment Methods',
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              const BankAccountCard(
                bankName: 'City Bank Limited',
                accountType: 'Savings Account',
                accountNumberSuffix: '3456',
                accountHolderName: 'Rafiul Islam',
              ),
              const SizedBox(height: 16),
              DashedAddButton(
                text: 'Add New Bank Account',
                onTap: () {
                  Get.toNamed(Routes.ADDBANKACCOUNT);
                },
              ),
              const SizedBox(height: 24),

              // Withdraw History
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Withdraw History',
                    style: GoogleFonts.outfit(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'View All',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF2E7D32), // Green color matching design
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Obx(
                  () => Column(
                    children: controller.withdrawHistory.asMap().entries.map((entry) {
                      int idx = entry.key;
                      var tx = entry.value;
                      bool isLast = idx == controller.withdrawHistory.length - 1;

                      return Container(
                        decoration: BoxDecoration(
                          border: isLast
                              ? null
                              : Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade100,
                                    width: 1,
                                  ),
                                ),
                        ),
                        child: WithdrawHistoryCard(
                          title: tx['title']!,
                          date: tx['date']!,
                          amount: tx['amount']!,
                          status: tx['status']!,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
