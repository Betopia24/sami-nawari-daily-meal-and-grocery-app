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
                  return const Center(
                    child: Text(
                      'No recipes found',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
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
