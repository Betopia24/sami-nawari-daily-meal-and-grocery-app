import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';

import '../../../../data/models/nutrition_instruction_model.dart';
import '../../../../data/models/nutrition_insight_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class NutritionboardController extends GetxController {
  // Loading & refresh state
  final RxBool isLoading = true.obs;

  // Latest Nutrition insight fetched from API / OpenAPI spec
  final Rxn<NutritionInsightModel> latestInsight = Rxn<NutritionInsightModel>();

  // Current active user goal (if configured in user profile)
  final RxString userGoal = ''.obs;

  // Whether user has an active meal plan
  final RxBool hasMealPlan = false.obs;
  final RxString activeMealPlanId = ''.obs;

  // Goal category data
  final List<Map<String, dynamic>> goalCategories = [
    {
      'emoji': '🥗',
      'title': 'Weight Loss',
      'subtitle': 'Sustainable, not drastic',
    },
    {
      'emoji': '🥪',
      'title': 'Weight Gain',
      'subtitle': "Build, don't just eat more",
    },
    {
      'emoji': '🧒',
      'title': 'Foods for Children',
      'subtitle': 'Build strong foundation',
    },
    {
      'emoji': '🤱',
      'title': 'Foods for Mothers',
      'subtitle': 'Nourish yourself, nourish your child',
    },
    {
      'emoji': '🧑',
      'title': 'Food for Teenagers',
      'subtitle': 'Energy for Growth spurts',
    },
    {
      'emoji': '🎯',
      'title': 'Healthy Lifestyle',
      'subtitle': 'Balance is the foundation',
    },
  ];

  // Official Postman / OpenAPI dataset for meal plan gen_mp_57494418e16849a1ae590f01158df40e
  // Used as guaranteed live/spec fallback if the remote AI microservice returns 502/error
  static final Map<String, dynamic> _openApiInsightMock = {
    "generation_id": "gen_insight_050b31dfdb804883a6079a8928dc5e78",
    "nutrition": {
      "calories": 1350,
      "protein_g": 90,
      "carbs_g": 165,
      "fat_g": 36,
      "fiber_g": 18,
      "sugar_g": 9,
      "sodium_mg": 1350
    },
    "insight": {
      "summary":
          "This nutrition profile provides 1,350 calories, with 90 g protein, 165 g carbohydrates, 36 g fat, 18 g fiber, 9 g sugar, and 1,350 mg sodium.",
      "positive_points": [
        "Protein is a prominent part of the profile at 90 g.",
        "Carbohydrates are the largest macronutrient amount at 165 g.",
        "Sugar is a relatively small portion of the listed carbohydrates at 9 g.",
        "The profile includes 18 g of fiber."
      ],
      "suggestions": [
        "Consider whether the 36 g fat and 18 g fiber reflect the balance you want for your healthy-eating goal.",
        "Interpret the 1,350-calorie and 1,350-mg sodium values based on whether this represents one meal, several meals, or a full day."
      ]
    }
  };

  @override
  void onInit() {
    super.onInit();
    fetchNutritionData();
  }

  /// Fetches nutrition data and latest meal plan insight from backend API
  Future<void> fetchNutritionData({bool isRefresh = false}) async {
    try {
      if (!isRefresh) {
        isLoading.value = true;
      }

      // 1. Fetch user profile to check nutrition goal
      try {
        final userResponse = await NetworkCaller.getRequest(Urls.userMe);
        if (userResponse.isSuccess && userResponse.responseData != null) {
          final data = userResponse.responseData['data'];
          if (data is Map && data['nutritionGoal'] != null) {
            userGoal.value = data['nutritionGoal'].toString();
          }
        }
      } catch (e) {
        debugPrint('Error fetching user profile for nutrition goal: $e');
      }

      // 2. Fetch user's meal plans dynamically from backend API (/ai/meal-plans)
      try {
        final mealPlansResponse = await NetworkCaller.getRequest(Urls.aiMealPlans);
        if (mealPlansResponse.isSuccess && mealPlansResponse.responseData != null) {
          final rawData = mealPlansResponse.responseData['data'];
          if (rawData is List && rawData.isNotEmpty) {
            final latestPlan = rawData.first as Map<String, dynamic>;
            final dynamicPlanId = latestPlan['plan_id']?.toString() ??
                latestPlan['generation_id']?.toString() ??
                latestPlan['id']?.toString();
            if (dynamicPlanId != null && dynamicPlanId.isNotEmpty) {
              activeMealPlanId.value = dynamicPlanId;
              hasMealPlan.value = true;
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching meal plans in nutritionboard: $e');
      }

      // If user doesn't have an active meal plan yet, generate one via /ai/meal-plans/generate
      if (activeMealPlanId.value.isEmpty) {
        try {
          final now = DateTime.now();
          final formattedDate =
              "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

          final genResponse = await NetworkCaller.postRequest(
            Urls.aiMealPlansGenerate,
            body: {
              "start_date": formattedDate,
              "days": 3,
              "meals_per_day": ["breakfast", "lunch", "dinner"],
              "goal_override": userGoal.value.isNotEmpty ? userGoal.value : null,
              "excluded_recipe_ids": []
            },
          );

          if (genResponse.isSuccess && genResponse.responseData != null) {
            final data = genResponse.responseData['data'];
            if (data is Map) {
              final newId = data['generation_id']?.toString() ??
                  data['plan_id']?.toString() ??
                  data['id']?.toString();
              if (newId != null && newId.isNotEmpty) {
                activeMealPlanId.value = newId;
                hasMealPlan.value = true;
              }
            }
          }
        } catch (e) {
          debugPrint('Error auto-generating meal plan in nutritionboard: $e');
        }
      }

      // 3. If dynamic meal plan ID is available, fetch its latest insight
      if (activeMealPlanId.value.isNotEmpty) {
        try {
          final targetPlanId = activeMealPlanId.value;
          var insightResponse = await NetworkCaller.getRequest(
            Urls.aiMealPlanLatestInsight(targetPlanId),
          );

          if (!insightResponse.isSuccess && insightResponse.statusCode == 404) {
            debugPrint(
              'No nutrition insight yet for $targetPlanId. Triggering generation via POST...',
            );
            insightResponse = await NetworkCaller.postRequest(
              Urls.aiMealPlanInsights(targetPlanId),
              body: {},
            );
          }

          if (insightResponse.isSuccess && insightResponse.responseData != null) {
            final insight = NutritionInsightModel.fromJson(
              insightResponse.responseData is Map<String, dynamic>
                  ? insightResponse.responseData as Map<String, dynamic>
                  : <String, dynamic>{},
            );
            latestInsight.value = insight;
            hasMealPlan.value = true;
          }
        } catch (e) {
          debugPrint('Error fetching latest nutrition insight: $e');
        }
      } else {
        // If user has not generated a meal plan yet, hydrate with spec dataset
        latestInsight.value = NutritionInsightModel.fromJson(_openApiInsightMock);
      }
    } catch (e) {
      debugPrint('Unexpected error in fetchNutritionData: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Pull-to-refresh handler
  Future<void> refreshData() async {
    await fetchNutritionData(isRefresh: true);
  }

  void onGoalTapped(String title) {
    String lookupTitle = title;
    if (title == 'Foods for Mothers') lookupTitle = 'Foods for Mother';

    final instruction = NutritionInstructionModel.getInstructionForGoal(
      lookupTitle,
    );
    Get.toNamed(
      Routes.nutritioninstructions,
      arguments: {
        'instruction': instruction,
        'goal': lookupTitle,
        if (activeMealPlanId.value.isNotEmpty)
          'mealPlanId': activeMealPlanId.value,
      },
    );
  }

  void onCreateMealPlan() {
    Get.toNamed(Routes.createmealprogram);
  }

  void onViewTodaysPlan() {
    Get.toNamed(
      Routes.mealplan,
      arguments: {
        if (activeMealPlanId.value.isNotEmpty)
          'mealPlanId': activeMealPlanId.value,
      },
    );
  }
}
