import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../navbar/controllers/navbar_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/daily_plan_banner.dart';
import '../widgets/dashboard_shimmer.dart';
import '../widgets/greeting_header.dart';
import '../widgets/homemade_food_card.dart';
import '../widgets/location_bar.dart';
import '../widgets/meal_category_card.dart';
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
        child: Obx(() {
          // Display shimmering skeleton while data is loading
          if (controller.isLoading.value) {
            return const DashboardShimmer();
          }

          return RefreshIndicator(
            onRefresh: controller.refreshDashboard,
            color: AppColors.primary,
            child: Column(
              children: [
                // Fixed Header Section with live user greeting & location
                Obx(
                  () => GreetingHeader(
                    greeting: controller.greetingMessage.value,
                    name: controller.userName.value,
                    onNotificationTap: () => Get.toNamed(Routes.notification),
                  ),
                ),
                Obx(
                  () => LocationBar(
                    location: controller.userLocation.value,
                    onTap: () {},
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100), // Space for floating navbar
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
                                  onTap: () => Get.toNamed(Routes.breakfastreceipes),
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
                          title: "Today's Meal Plan",
                          subtitle: 'Your personalized meals for today',
                        ),
                        DailyPlanBanner(onViewPlanTap: () => Get.toNamed(Routes.mealplan)),
                        const SizedBox(height: 16),

                        _buildSectionHeader(
                          title: 'Recommended For You',
                          subtitle: 'Based on your preferences, saves and favorites',
                          actionLabel: 'See all',
                          onActionTap: () => Get.toNamed(
                            Routes.recommendedfood,
                            arguments: controller.recommendedFoods.toList(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildRecommendedList(),
                        const SizedBox(height: 24),

                        _buildSectionHeader(
                          title: 'Shared Grocery',
                          actionLabel: 'Open List',
                          onActionTap: () {
                            if (Get.isRegistered<NavbarController>()) {
                              Get.find<NavbarController>().changePage(1);
                            } else {
                              Get.offAllNamed(Routes.navbar, arguments: {'tab': 1});
                            }
                          },
                        ),
                        SharedGroceryCard(
                          onTap: () {
                            if (Get.isRegistered<NavbarController>()) {
                              Get.find<NavbarController>().changePage(1);
                            } else {
                              Get.offAllNamed(Routes.navbar, arguments: {'tab': 1});
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildSectionHeader(
                          title: 'Homemade Food Near You',
                          subtitle: 'Neighbour kitchens - pickup or seller delivery',
                          actionLabel: 'See all',
                          onActionTap: () => Get.toNamed(
                            Routes.homemadefoodgrid,
                            arguments: controller.homemadeFoods.toList(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildHomemadeList(),
                        const SizedBox(height: 40), // Extra bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRecommendedList() {
    return Obx(() {
      final foods = controller.recommendedFoods;
      if (foods.isEmpty) {
        return Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Text(
            'No recommended recipes yet',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      return SizedBox(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            return RecipeCard(
              title: food.name,
              imagePath: food.firstImage.isNotEmpty
                  ? food.firstImage
                  : AppAssets.homeRecipeCardImage1,
              tag: food.category.isNotEmpty ? food.category : 'Chef special',
              time: food.preparationTime.isNotEmpty ? food.preparationTime : '20m',
              calories: food.calories,
              rating: food.rating,
              onTap: () => Get.toNamed(Routes.fooddetails, arguments: food),
            );
          },
        ),
      );
    });
  }

  Widget _buildHomemadeList() {
    return Obx(() {
      final foods = controller.homemadeFoods;
      if (foods.isEmpty) {
        return Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Text(
            'No homemade foods available right now',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      return SizedBox(
        height: 330,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            return HomemadeFoodCard(
              title: food.name,
              subtitle: food.displaySeller,
              imagePath: food.firstImage.isNotEmpty
                  ? food.firstImage
                  : AppAssets.homeRecipeCardImage3,
              distance: food.sellerAddress.isNotEmpty
                  ? food.sellerAddress.split(',').first
                  : '1.0 km',
              rating: '${food.rating} (120)',
              price: '\$${food.price.toStringAsFixed(2)}',
              onAddTap: () {
                Get.snackbar(
                  'Added to Cart',
                  '${food.name} added to cart',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: AppColors.primary,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              },
              onViewDetailsTap: () => Get.toNamed(Routes.fooddetails, arguments: food),
            );
          },
        ),
      );
    });
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
