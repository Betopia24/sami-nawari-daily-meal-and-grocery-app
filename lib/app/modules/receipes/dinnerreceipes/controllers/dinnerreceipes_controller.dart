import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';

class DinnerreceipesController extends GetxController {
  final tags = ['All', 'Family', 'Quick', 'Special', 'Comfort'];
  final selectedTagIndex = 0.obs;

  final List<Map<String, dynamic>> recipes = [
    {
      'imagePath': AppAssets.homeBreakfastCardImage, // using placeholder
      'tags': ['High Protein', 'Healthy', 'Quick'],
      'title': 'Avocado Toast with Poached Egg',
      'time': '15 min',
      'calories': '380 kcal',
      'rating': 4.8,
    },
    {
      'imagePath': AppAssets.homeLunchCardImage, // using placeholder
      'tags': ['Traditional', 'Spicy'],
      'title': 'Thai Green Curry',
      'time': '35 min',
      'calories': '520 kcal',
      'rating': 4.7,
    },
    {
      'imagePath': AppAssets.homeDinnerCardImage, // using placeholder
      'tags': ['High Protein'],
      'title': 'Lemon Herb Salmon',
      'time': '25 min',
      'calories': '440 kcal',
      'rating': 4.9,
    },
    {
      'imagePath': AppAssets.homeSnacksCardImage, // using placeholder
      'tags': ['Healthy'],
      'title': 'Mushroom Risotto',
      'time': '45 min',
      'calories': '490 kcal',
      'rating': 4.6,
    },
    {
      'imagePath': AppAssets.homeBreakfastCardImage, // using placeholder
      'tags': ['Quick', 'Healthy'],
      'title': 'Acai Power Bowl',
      'time': '10 min',
      'calories': '310 kcal',
      'rating': 4.8,
    },
    {
      'imagePath': AppAssets.homeLunchCardImage, // using placeholder
      'tags': ['Traditional'],
      'title': 'Shakshuka',
      'time': '30 min',
      'calories': '350 kcal',
      'rating': 4.7,
    },
  ];

  List<Map<String, dynamic>> get filteredRecipes {
    if (selectedTagIndex.value == 0) return recipes;
    final selectedTag = tags[selectedTagIndex.value];
    return recipes.where((recipe) {
      final recipeTags = recipe['tags'] as List;
      return recipeTags.contains(selectedTag);
    }).toList();
  }

  void onTagSelected(int index) {
    selectedTagIndex.value = index;
  }
}
