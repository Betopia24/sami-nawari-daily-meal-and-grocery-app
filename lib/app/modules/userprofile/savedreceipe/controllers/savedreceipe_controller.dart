import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';

class RecipeModel {
  final String imagePath;
  final String title;
  final String category;
  final String time;
  final double rating;

  RecipeModel({
    required this.imagePath,
    required this.title,
    required this.category,
    required this.time,
    required this.rating,
  });
}

class SavedreceipeController extends GetxController {
  final savedRecipes = <RecipeModel>[
    RecipeModel(
      imagePath: AppAssets.homeRecipeCardImage1, // Using mock image
      title: 'Avocado Toast with Poached Egg',
      category: 'American',
      time: '15 min',
      rating: 4.8,
    ),
    RecipeModel(
      imagePath: AppAssets.homeRecipeCardImage2, // Using mock image
      title: 'Lemon Herb Salmon',
      category: 'Mediterranean',
      time: '25 min',
      rating: 4.9,
    ),
    RecipeModel(
      imagePath: AppAssets.homeRecipeCardImage3, // Using mock image
      title: 'Shakshuka',
      category: 'Middle Eastern',
      time: '30 min',
      rating: 4.7,
    ),
  ].obs;

  void removeRecipe(int index) {
    // Just a placeholder to show it's interactive
    savedRecipes.removeAt(index);
  }
}
