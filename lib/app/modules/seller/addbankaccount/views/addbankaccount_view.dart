import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/wizard_step_indicator.dart';
import '../controllers/addbankaccount_controller.dart';
import '../widgets/step_one_bank_info.dart';
import '../widgets/step_three_additional_info.dart';
import '../widgets/step_two_account_info.dart';

class AddbankaccountView extends GetView<AddbankaccountController> {
  const AddbankaccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: CustomBackButton(),
        ),
        title: Text(
          'Add New Bank Account',
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Obx(() => WizardStepIndicator(
                    currentStep: controller.currentStep.value,
                    totalSteps: 3,
                  )),
            ),
            const Divider(color: Color(0xFFE5E7EB), thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Obx(() {
                  switch (controller.currentStep.value) {
                    case 1:
                      return const StepOneBankInfo();
                    case 2:
                      return const StepTwoAccountInfo();
                    case 3:
                      return const StepThreeAdditionalInfo();
                    default:
                      return const SizedBox.shrink();
                  }
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryButton(
                text: 'Continue',
                onPressed: controller.nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
