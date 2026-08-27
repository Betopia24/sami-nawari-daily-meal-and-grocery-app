import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/primary_button.dart';

import '../controllers/mealplan_controller.dart';

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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3FAEE), // Light green background
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.primary, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 28.sp),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getDayOfWeek(),
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                _getFormattedDate(),
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          )
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
                    
                    _buildMealCard(
                      time: '08:00 AM',
                      title: 'Breakfast',
                      subtitle: 'Oatmeal with Fruits',
                    ),
                    _buildMealCard(
                      time: '01:00 PM',
                      title: 'Lunch',
                      subtitle: 'Grilled Chicken Bowl',
                    ),
                    _buildMealCard(
                      time: '04:30 PM',
                      title: 'Snacks',
                      subtitle: 'Greek Yogurt with Berries',
                    ),
                    _buildMealCard(
                      time: '08:00 PM',
                      title: 'Dinner',
                      subtitle: 'Lentil & Vegetable Curry',
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ideabulb_icon.svg',
                          width: 24.w,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Drink enough water throughout the day',
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16.h),
                  ],
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
    required String time,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF3F3F3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFAFAFA),
              image: const DecorationImage(
                image: AssetImage('assets/images/homelunchcardimage.png'),
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
                  time,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';
  }
  
  String _getDayOfWeek() {
    final now = DateTime.now();
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return days[now.weekday - 1];
  }
}
