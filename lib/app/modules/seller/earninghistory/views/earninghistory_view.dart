import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../../app/routes/app_routes.dart';
import '../controllers/earninghistory_controller.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/transaction_card.dart';

class EarninghistoryView extends GetView<EarninghistoryController> {
  const EarninghistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F8),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: CustomBackButton(
            backgroundColor: Colors.white,
            onTap: () => Get.offNamed(Routes.earnings),
          ),
        ),
        title: Text(
          'Earnings History',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Filters and Dropdown Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Obx(
                        () => Row(
                          children: controller.filters.map((filter) {
                            return FilterChipWidget(
                              label: filter,
                              isSelected: controller.selectedFilter.value == filter,
                              onTap: () => controller.changeFilter(filter),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14),
                        const SizedBox(width: 6),
                        Obx(
                          () => DropdownButton<String>(
                            value: controller.selectedMonth.value,
                            borderRadius: BorderRadius.circular(16),
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(Icons.keyboard_arrow_down, size: 16),
                            ),
                            elevation: 4,
                            style: GoogleFonts.outfit(
                              color: Colors.black,
                              fontSize: 12,
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
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'August 2026',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  // Basic filtering logic
                  var filteredTransactions = controller.transactions;
                  if (controller.selectedFilter.value == 'Orders') {
                    filteredTransactions = filteredTransactions
                        .where((t) => t.isPositive)
                        .toList();
                  } else if (controller.selectedFilter.value == 'Withdraw') {
                    filteredTransactions = filteredTransactions
                        .where((t) => !t.isPositive)
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      return TransactionCard(
                        id: transaction.id,
                        amount: transaction.amount,
                        date: transaction.date,
                        time: transaction.time,
                        type: transaction.type,
                        isPositive: transaction.isPositive,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
