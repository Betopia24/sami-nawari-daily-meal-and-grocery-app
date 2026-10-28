import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import '../controllers/snacksreceipes_controller.dart';
import '../../widgets/recipes_header.dart';
import '../../widgets/filter_tags_row.dart';
import '../../widgets/recipe_list_card.dart';
import '../../widgets/recipe_list_shimmer.dart';

class SnacksreceipesView extends GetView<SnacksreceipesController> {
  const SnacksreceipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Obx(
              () => RecipesHeader(
                title: 'Snacks Recipes',
                subtitle: controller.isLoading.value
                    ? 'Loading recipes...'
                    : '${controller.filteredRecipes.length} recipes found',
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => FilterTagsRow(
                tags: controller.tags,
                selectedIndex: controller.selectedTagIndex.value,
                onTagSelected: controller.onTagSelected,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const RecipeListShimmer();
                }

                if (controller.filteredRecipes.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: controller.fetchRecipes,
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 80),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu_outlined,
                              size: 56,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No recipes found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Pull down to refresh',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchRecipes,
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: controller.filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = controller.filteredRecipes[index];
                      return RecipeListCard(
                        imagePath: recipe['imagePath'] as String,
                        tags: List<String>.from(recipe['tags'] as List),
                        title: recipe['title'] as String,
                        time: recipe['time'] as String,
                        calories: recipe['calories'] as String,
                        rating: (recipe['rating'] as num).toDouble(),
                        onTap: () => Get.toNamed(
                          '/receipedetails',
                          arguments: recipe,
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
