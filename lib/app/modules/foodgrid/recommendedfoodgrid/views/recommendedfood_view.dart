import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../dashboard/widgets/recipe_card.dart';
import '../../widgets/food_grid_template.dart';
import '../controllers/recommendedfood_controller.dart';

class RecommendedfoodView extends GetView<RecommendedfoodController> {
  const RecommendedfoodView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data to match the design
    final List<Map<String, String>> recipes = [
      {
        'title': 'Steamed Veg Dumplings',
        'imagePath': AppAssets.homeRecipeCardImage1,
        'tag': 'Previously viewed',
        'time': '50m',
        'calories': '310 kcal',
        'rating': '4.6',
      },
      {
        'title': 'Lemon Lentil Soup',
        'imagePath': AppAssets.doesNotExist, // Show fallback
        'tag': 'Previously viewed',
        'time': '25m',
        'calories': '290 kcal',
        'rating': '4.5',
      },
      {
        'title': 'Berry Overnight Oats',
        'imagePath': AppAssets.homeRecipeCardImage2,
        'tag': 'Favourite category',
        'time': '12m',
        'calories': '320 kcal',
        'rating': '4.8',
      },
      {
        'title': 'Herbed Rice & Veg Bowl',
        'imagePath': AppAssets.homeRecipeCardImage3,
        'tag': 'Favourite category',
        'time': '45m',
        'calories': '520 kcal',
        'rating': '4.9',
      },
      {
        'title': 'Grilled Veg Dinner Plate',
        'imagePath': AppAssets.homeRecipeCardImage1,
        'tag': 'Food preference',
        'time': '40m',
        'calories': '430 kcal',
        'rating': '4.7',
      },
      {
        'title': 'Masala Omelet Toast',
        'imagePath': AppAssets.homeRecipeCardImage2,
        'tag': 'Recently cooked',
        'time': '15m',
        'calories': '380 kcal',
        'rating': '4.6',
      },
    ];

    return FoodGridTemplate(
      title: 'Recommended For You',
      subtitle: 'Based on your preferences, saves and favorites',
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return RecipeCard(
          title: recipe['title']!,
          imagePath: recipe['imagePath']!,
          tag: recipe['tag']!,
          time: recipe['time']!,
          calories: recipe['calories']!,
          rating: recipe['rating']!,
          width: null,
          margin: EdgeInsets.zero,
          onTap: () => Get.toNamed(
            Routes.fooddetails,
            arguments: '6a8d6ca9e87759724844e5ec',
          ),
        );
      },
    );
  }
}
