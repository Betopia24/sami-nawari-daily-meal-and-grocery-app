import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import '../controllers/chooseyourplan_controller.dart';
import '../widgets/plan_option_card.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/custom_segmented_tab_bar.dart';

class ChooseyourplanView extends GetView<ChooseyourplanController> {
  const ChooseyourplanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: _buildHeader(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildToggleSwitch(),
                    SizedBox(height: 24),
                    Obx(() => _buildPlanList()),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomBackButton(),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your plan',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Find the plan that works best for you.',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSwitch() {
    return Obx(() {
      return CustomSegmentedTabBar(
        tabs: const ['Monthly', 'Yearly'],
        activeIndex: controller.isYearly.value ? 1 : 0,
        onTabChanged: (index) {
          controller.togglePlan(index == 1);
        },
      );
    });
  }

  Widget _buildPlanList() {
    final isYearly = controller.isYearly.value;
    final period = isYearly ? '/ year' : '/ month';

    return Column(
      children: [
        PlanOptionCard(
          title: 'Free / Basic',
          price: '0 NOK',
          period: period,
          features: [
            'Ads & Promotions',
            'AI Assistance',
            'No Referral Perks',
            'No Social Impact contribution',
          ],
          buttonText: 'Current Plan',
          isCurrentPlan: true,
          onButtonPressed: () {},
        ),
        PlanOptionCard(
          title: 'Pro',
          price: isYearly ? '500 NOK' : '50 NOK',
          period: period,
          features: [
            'Minimum Ads',
            'Limited AI consultation',
            'Share with 3 people, get 6-month Pro perk',
            '20% donated to Stop Hunger Globally',
          ],
          buttonText: 'Choose Pro',
          isPopular: true,
          isHighlighted: true,
          onButtonPressed: () {},
        ),
        PlanOptionCard(
          title: 'Premium',
          price: isYearly ? '700 NOK' : '70 NOK',
          period: period,
          features: [
            'No Ads',
            'Unlimited AI consultation',
            'Discounts on purchases across the platform',
            '20% donated to Stop Hunger Globally',
          ],
          buttonText: 'Choose Premium',
          onButtonPressed: () {},
        ),
      ],
    );
  }
}
