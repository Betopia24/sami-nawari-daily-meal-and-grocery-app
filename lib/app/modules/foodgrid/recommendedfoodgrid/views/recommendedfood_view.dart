import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../routes/app_routes.dart';
import '../../../dashboard/widgets/recipe_card.dart';
import '../../widgets/food_grid_template.dart';
import '../controllers/recommendedfood_controller.dart';

class RecommendedfoodView extends GetView<RecommendedfoodController> {
  const RecommendedfoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FoodGridTemplate(
        title: 'Recommended For You',
        subtitle: 'Based on your preferences, saves and favorites',
        isLoading: controller.isLoading.value,
        onRefresh: controller.fetchRecommendedFoods,
        itemCount: controller.foods.length,
        itemBuilder: (context, index) {
          final food = controller.foods[index];
          final tag = food.subcategory.isNotEmpty
              ? '${food.category} • ${food.subcategory}'
              : (food.category.isNotEmpty ? food.category : 'Recommended');

          return RecipeCard(
            title: food.name,
            imagePath: food.firstImage.isNotEmpty
                ? food.firstImage
                : AppAssets.homeRecipeCardImage1,
            tag: tag,
            time: food.preparationTime.isNotEmpty
                ? food.preparationTime
                : '20m',
            calories: food.calories.isNotEmpty ? food.calories : '310 kcal',
            rating: food.rating.isNotEmpty ? food.rating : '4.8',
            width: null,
            margin: EdgeInsets.zero,
            showAddButton: true,
            onAddTap: () => controller.addToCart(food),
            onTap: () => Get.toNamed(
              Routes.fooddetails,
              arguments: food,
            ),
          );
        },
      );
    });
  }
}
