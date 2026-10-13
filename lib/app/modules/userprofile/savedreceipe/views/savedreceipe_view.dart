import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../widgets/profile_app_bar.dart';
import '../../widgets/saved_recipe_card.dart';
import '../controllers/savedreceipe_controller.dart';

class SavedreceipeView extends GetView<SavedreceipeController> {
  const SavedreceipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: const ProfileAppBar(title: 'Saved Recipe'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 16.0, bottom: 8.0),
            child: Text(
              'Your Collection',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                itemCount: controller.savedRecipes.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final recipe = controller.savedRecipes[index];
                  return SavedRecipeCard(
                    imagePath: recipe.imagePath,
                    title: recipe.title,
                    category: recipe.category,
                    time: recipe.time,
                    rating: recipe.rating,
                    onTap: () {
                      // Navigate to recipe details
                    },
                    onBookmarkTap: () {
                      // Handle unsave
                      controller.removeRecipe(index);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
