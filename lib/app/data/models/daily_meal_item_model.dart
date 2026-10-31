import 'package:get/get.dart';

/// Model representing an individual meal item in the AI Daily Meal Plan
class DailyMealItemModel {
  final String mealType;
  final String title;
  final String recipeTitle;
  final String time;
  final String? imageUrl;
  final String? recipeId;
  final String? mealItemId;
  final int servings;
  final int? calories;

  DailyMealItemModel({
    required this.mealType,
    required this.title,
    required this.recipeTitle,
    required this.time,
    this.imageUrl,
    this.recipeId,
    this.mealItemId,
    this.servings = 1,
    this.calories,
  });

  factory DailyMealItemModel.fromJson(Map<String, dynamic> json) {
    final type = (json['meal_type'] ?? json['type'] ?? 'meal').toString();
    final formattedTitle = json['title']?.toString() ?? defaultTitle(type);
    final formattedTime = json['time']?.toString() ?? defaultTime(type);

    return DailyMealItemModel(
      mealType: type,
      title: formattedTitle,
      recipeTitle: (json['recipe_title'] ?? json['name'] ?? json['subtitle'] ?? 'Nutritious Meal').toString(),
      time: formattedTime,
      imageUrl: json['image_url'] ?? json['image'],
      recipeId: json['recipe_id']?.toString(),
      mealItemId: (json['meal_item_id'] ?? json['id'])?.toString(),
      servings: json['servings'] is int ? json['servings'] as int : 1,
      calories: json['calories'] is int ? json['calories'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meal_type': mealType,
      'title': title,
      'recipe_title': recipeTitle,
      'time': time,
      if (imageUrl != null) 'image_url': imageUrl,
      if (recipeId != null) 'recipe_id': recipeId,
      if (mealItemId != null) 'meal_item_id': mealItemId,
      'servings': servings,
      if (calories != null) 'calories': calories,
    };
  }

  static String defaultTitle(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'snacks':
      case 'snack':
        return 'Snacks';
      case 'dinner':
        return 'Dinner';
      default:
        return type.capitalizeFirst ?? type;
    }
  }

  static String defaultTime(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return '08:00 AM';
      case 'lunch':
        return '01:00 PM';
      case 'snacks':
      case 'snack':
        return '04:30 PM';
      case 'dinner':
        return '08:00 PM';
      default:
        return '12:00 PM';
    }
  }
}
