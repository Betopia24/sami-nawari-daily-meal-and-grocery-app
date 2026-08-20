import os

categories = [
    {"name": "breakfastreceipes", "title": "Breakfast Recipes", "tags": ["All", "Healthy", "Quick", "Traditional", "High Protein"]},
    {"name": "lunchreceipes", "title": "Lunch Recipes", "tags": ["All", "Light", "Quick", "Hearty", "Salads"]},
    {"name": "dinnerreceipes", "title": "Dinner Recipes", "tags": ["All", "Family", "Quick", "Special", "Comfort"]},
    {"name": "snacksreceipes", "title": "Snacks Recipes", "tags": ["All", "Healthy", "Quick", "Sweet", "Savory"]},
]

base_dir = "lib/app/modules/receipes"

for cat in categories:
    name = cat["name"]
    title = cat["title"]
    tags = cat["tags"]
    
    cap_name = name.capitalize()
    
    # View
    view_content = f"""import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/{name}_controller.dart';
import '../../widgets/recipes_header.dart';
import '../../widgets/filter_tags_row.dart';
import '../../widgets/recipe_list_card.dart';

class {cap_name}View extends GetView<{cap_name}Controller> {{
  const {cap_name}View({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Obx(() => RecipesHeader(
              title: '{title}',
              subtitle: '${{controller.filteredRecipes.length}} recipes found',
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
                itemBuilder: (context, index) {{
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
                }},
              )),
            ),
          ],
        ),
      ),
    );
  }}
}}
"""
    with open(f"{base_dir}/{name}/views/{name}_view.dart", "w") as f:
        f.write(view_content)

    # Controller
    controller_content = f"""import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';

class {cap_name}Controller extends GetxController {{
  final tags = {tags};
  final selectedTagIndex = 0.obs;

  final List<Map<String, dynamic>> recipes = [
    {{
      'imagePath': AppAssets.homeBreakfastCardImage, // using placeholder
      'tags': ['High Protein', 'Healthy', 'Quick'],
      'title': 'Avocado Toast with Poached Egg',
      'time': '15 min',
      'calories': '380 kcal',
      'rating': 4.8,
    }},
    {{
      'imagePath': AppAssets.homeLunchCardImage, // using placeholder
      'tags': ['Traditional', 'Spicy'],
      'title': 'Thai Green Curry',
      'time': '35 min',
      'calories': '520 kcal',
      'rating': 4.7,
    }},
    {{
      'imagePath': AppAssets.homeDinnerCardImage, // using placeholder
      'tags': ['High Protein'],
      'title': 'Lemon Herb Salmon',
      'time': '25 min',
      'calories': '440 kcal',
      'rating': 4.9,
    }},
    {{
      'imagePath': AppAssets.homeSnacksCardImage, // using placeholder
      'tags': ['Healthy'],
      'title': 'Mushroom Risotto',
      'time': '45 min',
      'calories': '490 kcal',
      'rating': 4.6,
    }},
    {{
      'imagePath': AppAssets.homeBreakfastCardImage, // using placeholder
      'tags': ['Quick', 'Healthy'],
      'title': 'Acai Power Bowl',
      'time': '10 min',
      'calories': '310 kcal',
      'rating': 4.8,
    }},
    {{
      'imagePath': AppAssets.homeLunchCardImage, // using placeholder
      'tags': ['Traditional'],
      'title': 'Shakshuka',
      'time': '30 min',
      'calories': '350 kcal',
      'rating': 4.7,
    }},
  ];

  List<Map<String, dynamic>> get filteredRecipes {{
    if (selectedTagIndex.value == 0) return recipes;
    final selectedTag = tags[selectedTagIndex.value];
    return recipes.where((recipe) {{
      final recipeTags = recipe['tags'] as List;
      return recipeTags.contains(selectedTag);
    }}).toList();
  }}

  void onTagSelected(int index) {{
    selectedTagIndex.value = index;
  }}
}}
"""
    with open(f"{base_dir}/{name}/controllers/{name}_controller.dart", "w") as f:
        f.write(controller_content)

    # Binding
    binding_content = f"""import 'package:get/get.dart';
import '../controllers/{name}_controller.dart';

class {cap_name}Binding extends Bindings {{
  @override
  void dependencies() {{
    Get.lazyPut<{cap_name}Controller>(
      () => {cap_name}Controller(),
    );
  }}
}}
"""
    with open(f"{base_dir}/{name}/bindings/{name}_binding.dart", "w") as f:
        f.write(binding_content)

print("Generated files")
