import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/breakfastreceipes_controller.dart';
import '../../widgets/recipes_header.dart';
import '../../widgets/filter_tags_row.dart';
import '../../widgets/recipe_list_card.dart';

class BreakfastreceipesView extends GetView<BreakfastreceipesController> {
  const BreakfastreceipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Obx(() => RecipesHeader(
              title: 'Breakfast Recipes',
              subtitle: '${controller.filteredRecipes.length} recipes found',
            )),
            const SizedBox(height: 16),
            Obx(() => FilterTagsRow(
                  tags: controller.tags,
                  selectedIndex: controller.selectedTagIndex.value,
                  onTagSelected: controller.onTagSelected,
                )),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() => ListView.builder(
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
                    onTap: () => Get.toNamed('/receipedetails'),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
