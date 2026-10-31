import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../data/network/network.dart';
import '../../../data/network/url.dart';
import '../../../widgets/custom_back_button.dart';
import '../controllers/groceries_controller.dart';
import '../widgets/meal_idea_card.dart';
import '../widgets/meal_inspiration_shimmer.dart';
import 'inspirationmealdetails_view.dart';

class AiMealProcessingView extends StatefulWidget {
  final List<String> selectedPantryItems;
  final List<String> recentPurchases;

  const AiMealProcessingView({
    super.key,
    this.selectedPantryItems = const [],
    this.recentPurchases = const [],
  });

  @override
  State<AiMealProcessingView> createState() => _AiMealProcessingViewState();
}

class _AiMealProcessingViewState extends State<AiMealProcessingView> {
  bool _isLoading = true;
  String _errorMessage = '';
  final List<Map<String, dynamic>> _mealIdeas = [];

  @override
  void initState() {
    super.initState();
    _fetchRealBackendRecommendations();
  }

  Future<void> _fetchRealBackendRecommendations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _mealIdeas.clear();
    });

    final List<String> pantry = widget.selectedPantryItems.isNotEmpty
        ? widget.selectedPantryItems
        : (Get.isRegistered<GroceriesController>()
            ? Get.find<GroceriesController>()
                .pendingItems
                .map((e) => e.title.trim())
                .where((t) => t.isNotEmpty)
                .toList()
            : <String>[]);

    final Set<String> seenIds = {};

    try {
      // 1. Fetch AI Food Recommendations: POST /ai/recommendations/foods
      try {
        final foodRecRes = await NetworkCaller.postRequest(
          Urls.aiRecommendFoods,
          body: {
            "limit": 10,
            "meal_type": "lunch",
            "delivery_zone_id": null,
            "exclude_food_ids": [],
          },
        );

        if (foodRecRes.isSuccess && foodRecRes.responseData != null) {
          final data = foodRecRes.responseData['data'];
          if (data is Map && data['items'] is List) {
            for (final itm in data['items']) {
              final food = itm['food'];
              if (food is Map) {
                _processBackendFood(food, pantry, seenIds, isAiRecommended: true);
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Error calling /ai/recommendations/foods: $e');
      }

      // 2. Fetch AI Recipe Recommendations: POST /ai/recommendations/recipes
      try {
        final recipeRecRes = await NetworkCaller.postRequest(
          Urls.aiRecommendRecipes,
          body: {
            "limit": 10,
            "meal_type": "lunch",
            "max_cooking_time_minutes": 60,
            "exclude_recipe_ids": [],
          },
        );

        if (recipeRecRes.isSuccess && recipeRecRes.responseData != null) {
          final data = recipeRecRes.responseData['data'];
          if (data is Map && data['items'] is List) {
            for (final itm in data['items']) {
              final recipe = itm['recipe'] ?? itm['food'];
              if (recipe is Map) {
                _processBackendFood(recipe, pantry, seenIds, isAiRecommended: true);
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Error calling /ai/recommendations/recipes: $e');
      }

      // 3. Fetch Real Published Foods from Backend Database: GET /foods
      try {
        final foodsRes = await NetworkCaller.getRequest(Urls.foods);
        if (foodsRes.isSuccess && foodsRes.responseData != null) {
          final data = foodsRes.responseData['data'];
          List foodList = [];
          if (data is Map && data['data'] is List) {
            foodList = data['data'];
          } else if (data is List) {
            foodList = data;
          }

          for (final raw in foodList) {
            if (raw is Map) {
              _processBackendFood(raw, pantry, seenIds, isAiRecommended: false);
            }
          }
        }
      } catch (e) {
        debugPrint('Error calling GET /foods: $e');
      }

      // Sort meals: meals using the most pantry items or with highest relevance appear first
      _mealIdeas.sort((a, b) {
        final countA = (a['matchingCount'] as int?) ?? 0;
        final countB = (b['matchingCount'] as int?) ?? 0;
        return countB.compareTo(countA);
      });
    } catch (e) {
      debugPrint('Error fetching recommendations from backend: $e');
      _errorMessage = 'Could not load meal recommendations. Please check your connection.';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _processBackendFood(
    Map food,
    List<String> pantry,
    Set<String> seenIds, {
    bool isAiRecommended = false,
  }) {
    final id = (food['id'] ?? food['_id'] ?? '').toString();
    if (id.isNotEmpty && seenIds.contains(id)) return;
    if (id.isNotEmpty) seenIds.add(id);

    final name = (food['name'] ?? food['title'] ?? 'Meal Idea').toString();
    final description = (food['description'] ?? '').toString();
    final prepTime = (food['preparationTime'] ?? '30 mins').toString();
    final category = (food['category'] ?? 'LUNCH').toString();

    // Extract Cloudinary / remote image
    String imageUrl = '';
    if (food['images'] is List && (food['images'] as List).isNotEmpty) {
      imageUrl = (food['images'] as List).first?.toString() ?? '';
    } else if (food['image'] != null) {
      imageUrl = food['image'].toString();
    }

    // Process ingredients from backend
    final List<Map<String, dynamic>> ingList = [];
    final List<String> missing = [];
    int matchCount = 0;

    if (food['ingredients'] is List) {
      for (final rawIng in food['ingredients']) {
        if (rawIng is Map) {
          final ingName = (rawIng['name'] ?? '').toString();
          final qty = (rawIng['quantity'] ?? '1').toString();
          final unit = (rawIng['unit'] ?? '').toString();

          final isMatch = pantry.any(
            (p) =>
                p.toLowerCase().contains(ingName.toLowerCase()) ||
                ingName.toLowerCase().contains(p.toLowerCase()),
          );

          if (isMatch) {
            matchCount++;
          } else if (ingName.isNotEmpty) {
            missing.add(ingName);
          }

          ingList.add({
            'name': ingName.isNotEmpty ? ingName : 'Ingredient',
            'amount': '$qty $unit'.trim(),
            'icon': 'assets/emojis/olive_emoji.png',
            'inPantry': isMatch,
          });
        }
      }
    }

    final usageText = matchCount > 0
        ? 'Uses $matchCount of your items'
        : (isAiRecommended ? 'AI Recommended' : 'Fresh Ingredients');

    // Method steps
    final List<Map<String, String>> steps = [];
    if (food['instructions'] is List) {
      for (var inst in food['instructions']) {
        if (inst is Map) {
          steps.add({
            'title': (inst['title'] ?? 'Instruction').toString(),
            'description': (inst['description'] ?? inst['step'] ?? '').toString(),
          });
        } else if (inst is String) {
          steps.add({
            'title': 'Step ${steps.length + 1}',
            'description': inst,
          });
        }
      }
    }

    final List<String> tips = [];
    if (food['proTips'] is List) {
      for (var t in food['proTips']) {
        tips.add(t.toString());
      }
    } else if (food['tips'] is List) {
      for (var t in food['tips']) {
        tips.add(t.toString());
      }
    }

    _mealIdeas.add({
      'id': id,
      'title': name,
      'timeInfo': '$prepTime • $category',
      'usageInfo': usageText,
      'imageUrl': imageUrl,
      'imageAsset': '',
      'difficulty': prepTime.contains('45') || prepTime.contains('60') ? 'Medium' : 'Easy',
      'prepTime': prepTime,
      'description': description,
      'ingredients': ingList,
      'methodSteps': steps,
      'proTips': tips,
      'missingIngredients': missing,
      'matchingCount': matchCount,
      'rawFood': food,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF9),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Row(
                children: [
                  const CustomBackButton(),
                  SizedBox(width: 16.w),
                  Icon(Icons.auto_awesome, color: AppColors.primary, size: 24.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meal Inspiration',
                          style: GoogleFonts.outfit(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Based on what you have and your\nrecent purchases',
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _fetchRealBackendRecommendations,
                  child: _buildBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // 1. Shimmer during loading
    if (_isLoading) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: MealInspirationShimmer(count: 4),
      );
    }

    // 2. Error message state
    if (_errorMessage.isNotEmpty && _mealIdeas.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 80.h),
          Center(
            child: Column(
              children: [
                Icon(Icons.cloud_off_rounded, size: 48.sp, color: AppColors.textSecondary),
                SizedBox(height: 16.h),
                Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  onPressed: _fetchRealBackendRecommendations,
                  child: Text(
                    'Retry',
                    style: GoogleFonts.outfit(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // 3. Empty state if no backend meals found
    if (_mealIdeas.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 80.h),
          Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5F3EB),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.kitchen_rounded, size: 48.sp, color: AppColors.primary),
                ),
                SizedBox(height: 16.h),
                Text(
                  'No meal recommendations found',
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Try selecting different pantry items or adding new items to get suggestions.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // 4. Real backend meals list
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _mealIdeas.length,
      itemBuilder: (context, index) {
        final meal = _mealIdeas[index];
        return MealIdeaCard(
          title: meal['title']?.toString() ?? '',
          timeInfo: meal['timeInfo']?.toString() ?? '',
          usageInfo: meal['usageInfo']?.toString() ?? '',
          imageUrl: meal['imageUrl']?.toString(),
          imageAsset: meal['imageAsset']?.toString(),
          onTap: () {
            Get.to(
              () => const InspirationmealdetailsView(),
              arguments: meal,
            );
          },
        );
      },
    );
  }
}
