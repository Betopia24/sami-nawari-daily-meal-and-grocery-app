import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/custom_dropdown_field.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/bankdetails_controller.dart';

class BankdetailsView extends GetView<BankdetailsController> {
  const BankdetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 72,
        leading: const CustomBackButton(),
        title: Text(
          'Bank Details',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Alert Box
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9).withValues(alpha: 0.5), // Light green background
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF3A8F5C)), // Green border
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F5E9),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              AppAssets.bankDetailsIcon,
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF3A8F5C),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Receive your earnings securely',
                                  style: GoogleFonts.outfit(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your payouts will be transferred to this bank account.',
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF6B7280),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.verified_outlined,
                                  color: Color(0xFF3A8F5C),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF3A8F5C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Bank Account Information',
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'ACCOUNT HOLDER NAME',
                      hint: '',
                      controller: controller.accountHolderNameController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'BANK NAME',
                      hint: '',
                      controller: controller.bankNameController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'ACCOUNT NUMBER',
                      hint: '',
                      controller: controller.accountNumberController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'ROUTING NUMBER (OPTIONAL)',
                      hint: '',
                      controller: controller.routingNumberController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: IgnorePointer(
                            child: CustomDropdownField<String>(
                              label: 'ACCOUNT TYPE',
                              value: controller.accountType.value,
                              items: [
                                DropdownMenuItem(
                                  value: 'Savings Account',
                                  child: Text('Savings Account', style: GoogleFonts.outfit(fontSize: 14)),
                                ),
                              ],
                              onChanged: (val) {},
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: IgnorePointer(
                            child: CustomDropdownField<String>(
                              label: 'CURRENCY',
                              value: controller.currency.value,
                              items: [
                                DropdownMenuItem(
                                  value: 'USD - US Dollar',
                                  child: Text('USD - US Dollar', style: GoogleFonts.outfit(fontSize: 14)),
                                ),
                              ],
                              onChanged: (val) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'SWIFT/BIC CODE (OPTIONAL)',
                      subLabel: 'Required for International transfers',
                      hint: '',
                      controller: controller.swiftCodeController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Edit Details',
                    onPressed: controller.editDetails,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: controller.removeBankAccount,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      side: const BorderSide(color: Color(0xFFFF4D4F)), // Red border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: const Color(0xFFFFF1F0), // Light red background
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFFF4D4F),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Remove Bank Account',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFFF4D4F),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
