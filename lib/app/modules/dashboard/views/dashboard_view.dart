import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/daily_plan_banner.dart';
import '../widgets/greeting_header.dart';
import '../widgets/homemade_food_card.dart';
import '../widgets/location_bar.dart';
import '../widgets/meal_category_card.dart';
import '../../../widgets/nutrition_goal_card.dart';
import '../../../data/models/nutrition_instruction_model.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/shared_grocery_card.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Fixed Header Section
            GreetingHeader(
              greeting: 'Good Morning',
              name: 'Rafi',
              onNotificationTap: () => Get.toNamed(Routes.notification),
            ),
            LocationBar(location: 'San Francisco, CA', onTap: () {}),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ), // Space for floating navbar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DashboardSearchBar(),

                    _buildSectionHeader(
                      title: 'What are you cooking today?',
                      subtitle: 'Pick a meal to see matching recipes',
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: MealCategoryCard(
                              title: 'Breakfast',
                              imagePath: AppAssets.homeBreakfastCardImage,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFF8EE),
                                  AppColors.backgroundNotification,
                                ],
                              ),
                              onTap: () =>
                                  Get.toNamed(Routes.breakfastreceipes),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: MealCategoryCard(
                              title: 'Lunch',
                              imagePath: AppAssets.homeLunchCardImage,
                              color: const Color.fromRGBO(58, 143, 92, 0.1),
                              onTap: () => Get.toNamed(Routes.lunchreceipes),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: MealCategoryCard(
                              title: 'Dinner',
                              imagePath: AppAssets.homeDinnerCardImage,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFF5F0FF), Color(0xFFEDE8FF)],
                              ),
                              onTap: () => Get.toNamed(Routes.dinnerreceipes),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: MealCategoryCard(
                              title: 'Snacks',
                              imagePath: AppAssets.homeSnacksCardImage,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFFFF0F0), Color(0xFFFFE8E8)],
                              ),
                              onTap: () => Get.toNamed(Routes.snacksreceipes),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionHeader(
                      title: 'Today\'s Meal Plan',
                      subtitle: 'Your personalized meals for today',
                    ),
                    DailyPlanBanner(onViewPlanTap: () => Get.toNamed(Routes.mealplan)),
                    const SizedBox(height: 16),

                    _buildSectionHeader(
                      title: 'Recommended For You',
                      subtitle:
                          'Based on your preferences, saves and favorites',
                      actionLabel: 'See all',
                      onActionTap: () => Get.toNamed(Routes.recommendedfood),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 250,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        children: [
                          RecipeCard(
                            title: 'Steamed Veg Dumplings',
                            imagePath: AppAssets.homeRecipeCardImage1,
                            tag: 'Previously viewed',
                            time: '50m',
                            calories: '310 kcal',
                            rating: '4.6',
                            onTap: () {},
                          ),
                          RecipeCard(
                            title: 'Lemon Lentil Soup',
                            imagePath: AppAssets
                                .doesNotExist, // Invalid path to show fallback
                            tag: 'Previously viewed',
                            time: '25m',
                            calories: '290 kcal',
                            rating: '4.5',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionHeader(
                      title: 'Shared Grocery',
                      actionLabel: 'Open List',
                    ),
                    SharedGroceryCard(onTap: () {}),
                    const SizedBox(height: 16),

                    _buildSectionHeader(
                      title: 'Homemade Food Near You',
                      subtitle:
                          'Neighbour kitchens - pickup or seller delivery',
                      actionLabel: 'See all',
                      onActionTap: () => Get.toNamed(Routes.homemadefoodgrid),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 330,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        children: [
                          HomemadeFoodCard(
                            title: 'Chicken Biryani Tiffin',
                            subtitle: 'Amina\'s Home Kitchen',
                            imagePath: AppAssets.homeRecipeCardImage3,
                            distance: '0.8 km',
                            rating: '4.9 (214)',
                            price: '\$6.50',
                            onAddTap: () {},
                            onViewDetailsTap: () =>
                                Get.toNamed(Routes.fooddetails),
                          ),
                          HomemadeFoodCard(
                            title: 'Steamed Veg Dumplings',
                            subtitle: 'Mei\'s Dumpling Table',
                            imagePath: AppAssets
                                .doesNotExist, // Invalid path to show fallback
                            distance: '1.4 km',
                            rating: '4.7 (132)',
                            price: '\$4.00',
                            onAddTap: () {},
                            onViewDetailsTap: () =>
                                Get.toNamed(Routes.fooddetails),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40), // Extra bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onActionTap ?? () {},
              child: Text(
                actionLabel,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
