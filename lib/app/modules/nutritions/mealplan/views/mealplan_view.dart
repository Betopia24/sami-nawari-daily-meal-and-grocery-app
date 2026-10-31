import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../data/models/daily_meal_item_model.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/mealplan_controller.dart';
import '../widgets/meal_plan_shimmer.dart';

class MealplanView extends GetView<MealplanController> {
  const MealplanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 24.w),
          child: const CustomBackButton(),
        ),
        leadingWidth: 64.w,
        title: Text(
          "Today's Meal Plan",
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(color: Color(0xFFF3F3F3), height: 1),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshMealPlan,
                color: AppColors.primary,
                backgroundColor: Colors.white,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const MealPlanShimmer();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dynamic Date Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3FAEE),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.primary, width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: AppColors.primary,
                                size: 28.sp,
                              ),
                              SizedBox(width: 16.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.dayOfWeek.value,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    controller.dateString.value,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        Center(
                          child: Text(
                            'Your personalized meals for today',
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        Text(
                          "Today's Meals",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Dynamic Meals List from API
                        ...controller.meals.map(
                          (meal) => _buildMealCard(
                            meal: meal,
                            onTap: () => controller.onMealItemTapped(meal),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // AI Advice / Tip Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ideabulb_icon.svg',
                              width: 24.w,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                controller.tipText.value,
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
              child: PrimaryButton(
                text: "Continue",
                onPressed: controller.onContinue,
                showArrow: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard({
    required DailyMealItemModel meal,
    required VoidCallback onTap,
  }) {
    final defaultAsset = _getImageForMealType(meal.mealType);
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF3F3F3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFAFAFA),
                    image: (meal.imageUrl != null && meal.imageUrl!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(meal.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage(defaultAsset),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.time,
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        meal.title,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        meal.recipeTitle,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getImageForMealType(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return AppAssets.homeBreakfastCardImage;
      case 'lunch':
        return AppAssets.homeLunchCardImage;
      case 'snacks':
      case 'snack':
        return AppAssets.homeSnacksCardImage;
      case 'dinner':
        return AppAssets.homeDinnerCardImage;
      default:
        return AppAssets.homeLunchCardImage;
    }
  }
}
