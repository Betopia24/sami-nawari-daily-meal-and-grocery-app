import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/earnings_controller.dart';
import '../widgets/earnings_chart_card.dart';
import '../widgets/stat_summary_card.dart';

class EarningsView extends GetView<EarningsController> {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFB),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: const CustomBackButton(backgroundColor: Colors.white),
        ),
        title: Text(
          'Earnings',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header Row (Dropdown + View History)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 18),
                        const SizedBox(width: 8),
                        Obx(
                          () => DropdownButton<String>(
                            value: controller.selectedMonth.value,
                            borderRadius: BorderRadius.circular(16),
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(Icons.keyboard_arrow_down, size: 20),
                            ),
                            elevation: 4,
                            style: GoogleFonts.outfit(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            underline: const SizedBox(),
                            isDense: true,
                            onChanged: (String? value) {
                              if (value != null) {
                                controller.selectedMonth.value = value;
                              }
                            },
                            items: controller.months
                                .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                })
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Get.toNamed(Routes.earninghistory);
                    },
                    icon: const Icon(
                      Icons.history,
                      color: Colors.black,
                      size: 18,
                    ),
                    label: Text(
                      'View History',
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Graph Card
              Obx(
                () => EarningsChartCard(
                  totalEarnings: controller.totalEarnings.value,
                  percentage: controller.earningsPercentage.value,
                  chartData: controller.chartData,
                  bottomTitles: controller.bottomTitles,
                ),
              ),
              const SizedBox(height: 24),

              // Summary Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: IntrinsicHeight(
                  child: Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        StatSummaryCard(
                          title: 'Completed Orders',
                          value: controller.completedOrders.value.toString(),
                          subtitlePrefix:
                              '↑ ${controller.completedOrdersPercentage.value}%',
                          subtitleSuffix: 'from this month',
                          isPositive: true,
                        ),
                        StatSummaryCard(
                          title: 'Pending Earnings',
                          value:
                              '\$${controller.pendingEarnings.value.toStringAsFixed(2)}',
                          subtitleSuffix:
                              '${controller.pendingOrdersCount.value} orders',
                        ),
                        StatSummaryCard(
                          title: 'Available Balance',
                          value:
                              '\$${controller.availableBalance.value.toStringAsFixed(2)}',
                          subtitleSuffix: 'Ready for withdraw',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // Withdraw Button
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: PrimaryButton(
                  text: 'Withdraw',
                  svgPrefix: AppAssets.withdrawIcon,
                  showArrow: false,
                  onPressed: () => Get.toNamed(Routes.WITHDRAWREQUEST),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
