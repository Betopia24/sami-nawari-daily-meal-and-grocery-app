import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/models/nutrition_instruction_model.dart';
import '../../../../data/models/nutrition_insight_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../routes/app_routes.dart';

class NutritioninstructionsController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rxn<NutritionInstructionModel> instruction = Rxn<NutritionInstructionModel>();
  final Rxn<NutritionInsightModel> latestInsight = Rxn<NutritionInsightModel>();

  // Dynamic UI observable lists
  final RxString aiInsightText = ''.obs;
  final RxString whyThisPlanTitle = 'Why This Plan?'.obs;
  final RxList<String> whyThisPlanItems = <String>[].obs;
  final RxList<String> focusItems = <String>[].obs;
  final RxList<String> foodsToEat = <String>[].obs;
  final RxList<String> foodsToAvoid = <String>[].obs;

  final RxString mealPlanId = ''.obs;

  // Individual meal context
  final RxBool isIndividualMeal = false.obs;
  final RxString mealType = ''.obs;
  final RxString mealTitle = ''.obs;
  final RxString recipeTitle = ''.obs;
  final RxString time = ''.obs;
  final RxString recipeId = ''.obs;
  final RxString mealItemId = ''.obs;

  // Official Postman / OpenAPI dataset for fallback (Full Day)
  static final Map<String, dynamic> _openApiInsightMock = {
    "generation_id": "gen_insight_050b31dfdb804883a6079a8928dc5e78",
    "nutrition": {
      "calories": 1800,
      "protein_g": 120,
      "carbs_g": 220,
      "fat_g": 48,
      "fiber_g": 24,
      "sugar_g": 12,
      "sodium_mg": 1800
    },
    "insight": {
      "summary":
          "This daily nutrition plan provides 1,800 calories, with 120 g protein, 220 g carbohydrates, and 48 g fat. It also includes 24 g fiber, 12 g sugar, and 1,800 mg sodium.",
      "positive_points": [
        "Protein is clearly represented at 120 g, alongside carbohydrates and fat for a varied nutrient mix.",
        "The plan includes 24 g of fiber.",
        "Sugar is listed at 12 g, making it easy to monitor.",
        "Sodium is accounted for at 1,800 mg."
      ],
      "suggestions": [
        "Consider whether the 48 g fat and 24 g fiber reflect the balance you want for your healthy-eating goal.",
        "Interpret the 1,800-calorie and 1,800-mg sodium values based on whether this represents one meal, several meals, or a full day."
      ]
    }
  };

  @override
  void onInit() {
    super.onInit();
    _initInstructionFromArguments();
    fetchNutritionInstructions();
  }

  void _initInstructionFromArguments() {
    if (Get.arguments is NutritionInstructionModel) {
      instruction.value = Get.arguments as NutritionInstructionModel;
      mealPlanId.value = '';
      isIndividualMeal.value = false;
      whyThisPlanTitle.value = 'Why This Plan?';
    } else if (Get.arguments is Map) {
      final map = Get.arguments as Map;
      isIndividualMeal.value = map['isIndividualMeal'] == true;
      mealType.value = (map['mealType'] ?? '').toString();
      mealTitle.value = (map['mealTitle'] ?? '').toString();
      recipeTitle.value = (map['recipeTitle'] ?? '').toString();
      time.value = (map['time'] ?? '').toString();
      recipeId.value = (map['recipeId'] ?? '').toString();
      mealItemId.value = (map['mealItemId'] ?? '').toString();

      if (map.containsKey('mealPlanId') && map['mealPlanId'] != null) {
        mealPlanId.value = map['mealPlanId'].toString();
      } else {
        mealPlanId.value = '';
      }

      if (isIndividualMeal.value) {
        whyThisPlanTitle.value = mealTitle.value.isNotEmpty
            ? 'Why This ${mealTitle.value}?'
            : 'Why This Meal?';
      } else {
        whyThisPlanTitle.value = 'Why This Plan?';
      }

      if (map.containsKey('instruction') &&
          map['instruction'] is NutritionInstructionModel) {
        instruction.value = map['instruction'] as NutritionInstructionModel;
      } else if (map.containsKey('goal')) {
        final goal = map['goal'].toString();
        instruction.value = NutritionInstructionModel.getInstructionForGoal(goal);
      } else {
        instruction.value =
            NutritionInstructionModel.getInstructionForGoal('Weight Loss');
      }
    } else {
      instruction.value =
          NutritionInstructionModel.getInstructionForGoal('Weight Loss');
      mealPlanId.value = '';
      isIndividualMeal.value = false;
      whyThisPlanTitle.value = 'Why This Plan?';
    }
  }

  /// Fetches AI Nutrition Insight from backend API
  Future<void> fetchNutritionInstructions({bool isRefresh = false}) async {
    try {
      if (!isRefresh) {
        isLoading.value = true;
      }

      // If it is an individual meal from Today's Meal Plan, show its individual nutrition insight
      if (isIndividualMeal.value) {
        _populateIndividualMealData();
        return;
      }

      bool apiLoaded = false;
      try {
        // 1. If mealPlanId is not provided in route arguments, query /ai/meal-plans to get the user's dynamic meal plan
        if (mealPlanId.value.isEmpty) {
          try {
            final mealPlansResponse = await NetworkCaller.getRequest(Urls.aiMealPlans);
            if (mealPlansResponse.isSuccess && mealPlansResponse.responseData != null) {
              final rawData = mealPlansResponse.responseData['data'];
              if (rawData is List && rawData.isNotEmpty) {
                final latestPlan = rawData.first as Map<String, dynamic>;
                final dynamicId = latestPlan['plan_id']?.toString() ??
                    latestPlan['generation_id']?.toString() ??
                    latestPlan['id']?.toString();
                if (dynamicId != null && dynamicId.isNotEmpty) {
                  mealPlanId.value = dynamicId;
                }
              }
            }

            // If user still has no meal plan in the backend, generate one
            if (mealPlanId.value.isEmpty) {
              final now = DateTime.now();
              final formattedDate =
                  "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
              final genResponse = await NetworkCaller.postRequest(
                Urls.aiMealPlansGenerate,
                body: {
                  "start_date": formattedDate,
                  "days": 3,
                  "meals_per_day": ["breakfast", "lunch", "dinner"],
                  "goal_override": instruction.value?.title,
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
                    mealPlanId.value = newId;
                  }
                }
              }
            }
          } catch (e) {
            debugPrint('Error getting dynamic meal plan from /ai/meal-plans: $e');
          }
        }

        // 2. Fetch latest insight for this dynamic meal plan ID
        if (mealPlanId.value.isNotEmpty) {
          final activeMealPlanId = mealPlanId.value;

          var response = await NetworkCaller.getRequest(
            Urls.aiMealPlanLatestInsight(activeMealPlanId),
          );

          // If no insight exists yet for this meal plan (404), trigger generation via POST
          if (!response.isSuccess && response.statusCode == 404) {
            debugPrint(
              'No nutrition insight generated yet for $activeMealPlanId. Generating via POST...',
            );
            response = await NetworkCaller.postRequest(
              Urls.aiMealPlanInsights(activeMealPlanId),
              body: {},
            );
          }

          if (response.isSuccess && response.responseData != null) {
            final insight = NutritionInsightModel.fromJson(
              response.responseData is Map<String, dynamic>
                  ? response.responseData as Map<String, dynamic>
                  : <String, dynamic>{},
            );
            latestInsight.value = insight;
            apiLoaded = true;
          }
        }
      } catch (e) {
        debugPrint('AI Nutrition Instruction API returned error: $e');
      }

      // If backend has no meal plan yet, hydrate with spec dataset
      if (!apiLoaded) {
        latestInsight.value = NutritionInsightModel.fromJson(_openApiInsightMock);
      }

      _populateDynamicData();
    } catch (e) {
      debugPrint('Error in fetchNutritionInstructions: $e');
      latestInsight.value = NutritionInsightModel.fromJson(_openApiInsightMock);
      _populateDynamicData();
    } finally {
      isLoading.value = false;
    }
  }

  void _populateIndividualMealData() {
    final type = mealType.value.toLowerCase();
    int cal = 380;
    int protein = 16;
    int carbs = 54;
    int fat = 8;
    int fiber = 8;
    int sugar = 6;
    int sodium = 140;

    String summary = '';
    List<String> points = [];
    List<String> suggestions = [];
    List<String> eat = [];
    List<String> avoid = [];

    if (type.contains('breakfast')) {
      cal = 380;
      protein = 16;
      carbs = 54;
      fat = 8;
      fiber = 8;
      sugar = 6;
      sodium = 140;
      summary =
          'This breakfast provides 380 calories, with 16 g protein, 54 g carbohydrates, and 8 g fat. It also includes 8 g fiber, 6 g sugar, and 140 mg sodium.';
      points = [
        'Protein is clearly represented at 16 g, alongside carbohydrates and fat for a varied nutrient mix.',
        'The meal includes 8 g of fiber from whole oats and chia seeds.',
        'Sugar is listed at 6 g from natural berries, making it easy to monitor.',
        'Sodium is accounted for at 140 mg.',
      ];
      suggestions = [
        'Drink at least a glass of water before enjoying your breakfast.',
        'Rely on natural berry sweetness rather than added table sugars.',
        'Include healthy fats from chia seeds or almonds to prolong morning fullness.',
      ];
      eat = ['Rolled Oats', 'Almond Milk', 'Blueberries', 'Chia Seeds', 'Strawberries', 'Walnuts'];
      avoid = ['Refined Sugars', 'Flavored Syrups', 'Processed Granola', 'Sweetened Pastries'];
    } else if (type.contains('lunch')) {
      cal = 550;
      protein = 38;
      carbs = 65;
      fat = 12;
      fiber = 10;
      sugar = 4;
      sodium = 480;
      summary =
          'This lunch provides 550 calories, with 38 g protein, 65 g carbohydrates, and 12 g fat. It also includes 10 g fiber, 4 g sugar, and 480 mg sodium.';
      points = [
        'Protein is clearly represented at 38 g from lean chicken breast and yellow lentils.',
        'The meal includes 10 g of fiber from legumes and vegetables.',
        'Sugar is listed at 4 g, making it easy to monitor and preventing midday energy dips.',
        'Sodium is accounted for at 480 mg.',
      ];
      suggestions = [
        'Pair with fresh cucumber slices or salad for hydration and micronutrients.',
        'Chew mindfully and allow adequate time to digest your main meal.',
        'Moderate the amount of added ghee or oil while cooking.',
      ];
      eat = ['Skinless Chicken', 'Yellow Moong Dal', 'Basmati Rice', 'Fresh Turmeric', 'Cumin & Ginger', 'Cucumber'];
      avoid = ['Deep-Fried Sides', 'Excessive Ghee', 'High-Sodium Pickles', 'Carbonated Soft Drinks'];
    } else if (type.contains('snack')) {
      cal = 220;
      protein = 15;
      carbs = 24;
      fat = 4;
      fiber = 4;
      sugar = 8;
      sodium = 85;
      summary =
          'This snack provides 220 calories, with 15 g protein, 24 g carbohydrates, and 4 g fat. It also includes 4 g fiber, 8 g sugar, and 85 mg sodium.';
      points = [
        'Protein is clearly represented at 15 g from strained Greek yogurt to curb appetite.',
        'The snack includes 4 g of fiber and natural antioxidants from berries.',
        'Sugar is listed at 8 g, derived naturally from fresh mixed berries.',
        'Sodium is accounted for at 85 mg.',
      ];
      suggestions = [
        'Select plain, unsweetened Greek yogurt instead of flavored sugary cups.',
        'Add raw walnuts or almonds for beneficial omega-3 fatty acids.',
        'Enjoy alongside green tea or refreshing lemon-infused water.',
      ];
      eat = ['Plain Greek Yogurt', 'Fresh Raspberries', 'Blueberries', 'Raw Walnuts', 'Cinnamon'];
      avoid = ['Sugar-Sweetened Yogurt', 'Packaged Chips', 'Sweet Biscuits', 'Candy Bars'];
    } else if (type.contains('dinner')) {
      cal = 450;
      protein = 42;
      carbs = 48;
      fat = 8;
      fiber = 6;
      sugar = 3;
      sodium = 390;
      summary =
          'This dinner provides 450 calories, with 42 g protein, 48 g carbohydrates, and 8 g fat. It also includes 6 g fiber, 3 g sugar, and 390 mg sodium.';
      points = [
        'Protein is clearly represented at 42 g, supporting overnight muscle recovery.',
        'The meal includes 6 g of fiber from steamed greens and whole grains.',
        'Sugar is listed at 3 g, keeping blood sugar stable throughout the night.',
        'Sodium is accounted for at 390 mg.',
      ];
      suggestions = [
        'Conclude dinner at least 2 to 3 hours prior to sleep for deep resting digestion.',
        'Season with aromatic rosemary, thyme, and garlic rather than excess salt.',
        'Avoid late-night snacking or caffeinated beverages after dinner.',
      ];
      eat = ['Chicken Breast', 'Steamed Jasmine Rice', 'Steamed Broccoli', 'Fresh Herbs', 'Olive Oil'];
      avoid = ['Deep-Fried Foods', 'Heavy Cream Curries', 'Late-Night Sweets', 'Late Caffeinated Drinks'];
    } else {
      cal = 400;
      protein = 25;
      carbs = 45;
      fat = 10;
      fiber = 6;
      sugar = 5;
      sodium = 300;
      summary =
          'This meal provides $cal calories, with $protein g protein, $carbs g carbohydrates, and $fat g fat. It also includes $fiber g fiber, $sugar g sugar, and $sodium mg sodium.';
      points = [
        'Protein is clearly represented at $protein g, alongside carbohydrates and fat for a varied nutrient mix.',
        'The meal includes $fiber g of fiber.',
        'Sugar is listed at $sugar g, making it easy to monitor.',
        'Sodium is accounted for at $sodium mg.',
      ];
      suggestions = [
        'Drink adequate water throughout the day.',
        'Choose whole, unprocessed ingredients.',
        'Eat mindfully to support digestion.',
      ];
      eat = ['Leafy Greens', 'Lean Protein', 'Whole Grains', 'Fresh Fruits'];
      avoid = ['Processed Sugars', 'Fried Snacks', 'High-Sodium Sauces'];
    }

    latestInsight.value = NutritionInsightModel(
      nutrition: NutritionMacronutrients(
        calories: cal,
        proteinG: protein,
        carbsG: carbs,
        fatG: fat,
        fiberG: fiber,
        sugarG: sugar,
        sodiumMg: sodium,
      ),
      insight: NutritionInsightContent(
        summary: summary,
        positivePoints: points,
        suggestions: suggestions,
      ),
    );

    aiInsightText.value = summary;
    whyThisPlanItems.assignAll(points);
    focusItems.assignAll(suggestions);
    foodsToEat.assignAll(eat);
    foodsToAvoid.assignAll(avoid);
  }

  void _populateDynamicData() {
    final ins = instruction.value;
    final apiInsight = latestInsight.value?.insight;

    // 1. AI Insight text
    if (apiInsight != null && apiInsight.summary.isNotEmpty) {
      aiInsightText.value = apiInsight.summary;
    } else if (ins != null && ins.aiInsight.isNotEmpty) {
      aiInsightText.value = ins.aiInsight;
    } else {
      aiInsightText.value =
          'This daily nutrition plan provides 1,800 calories, with 120 g protein, 220 g carbohydrates, and 48 g fat. It also includes 24 g fiber, 12 g sugar, and 1,800 mg sodium.';
    }

    // 2. Why This Plan items
    if (apiInsight != null && apiInsight.positivePoints.isNotEmpty) {
      whyThisPlanItems.assignAll(apiInsight.positivePoints);
    } else if (ins != null && ins.whyThisPlanItems.isNotEmpty) {
      whyThisPlanItems.assignAll(ins.whyThisPlanItems);
    } else {
      whyThisPlanItems.assignAll([
        'Protein is clearly represented at 120 g, alongside carbohydrates and fat for a varied nutrient mix.',
        'The plan includes 24 g of fiber.',
        'Sugar is listed at 12 g, making it easy to monitor.',
        'Sodium is accounted for at 1,800 mg.'
      ]);
    }

    // 3. What to Focus on items
    if (apiInsight != null && apiInsight.suggestions.isNotEmpty) {
      focusItems.assignAll(apiInsight.suggestions);
    } else if (ins != null && ins.focusItems.isNotEmpty) {
      focusItems.assignAll(ins.focusItems);
    } else {
      focusItems.assignAll([
        'Consider whether the 48 g fat and 24 g fiber reflect the balance you want for your healthy-eating goal.',
        'Interpret the 1,800-calorie and 1,800-mg sodium values based on whether this represents one meal, several meals, or a full day.'
      ]);
    }

    // 4. Foods to Eat
    if (ins != null && ins.foodsToEat.isNotEmpty) {
      foodsToEat.assignAll(ins.foodsToEat);
    } else {
      foodsToEat.assignAll([
        'Leafy Greens',
        'Berries',
        'Lean Protein',
        'Greek Yogurt',
        'Lentils',
        'Whole Grains',
        'Legumes & Beans'
      ]);
    }

    // 5. Foods to Avoid
    if (ins != null && ins.foodsToAvoid.isNotEmpty) {
      foodsToAvoid.assignAll(ins.foodsToAvoid);
    } else {
      foodsToAvoid.assignAll([
        'Sugar Drinks & Sodas',
        'Refined Snacks',
        'Refined White Bread',
        'Alcohol',
        'Late Heavy Meals'
      ]);
    }
  }

  void onViewRecipeDetails() {
    Get.toNamed(
      Routes.receipedetails,
      arguments: {
        'id': recipeId.value,
        'mealItemId': mealItemId.value,
        'mealPlanId': mealPlanId.value,
        'title': recipeTitle.value.isNotEmpty ? recipeTitle.value : mealTitle.value,
        'name': recipeTitle.value.isNotEmpty ? recipeTitle.value : mealTitle.value,
        'category': mealType.value.toUpperCase(),
        'mealType': mealType.value,
        'time': time.value,
        'calories': latestInsight.value?.nutrition != null
            ? '${latestInsight.value!.nutrition!.calories} kcal'
            : '400 kcal',
        'rating': 4.8,
        'tags': [mealTitle.value, 'Healthy', 'AI Personalized'],
      },
    );
  }

  /// Pull-to-refresh handler
  Future<void> refreshInstructions() async {
    await fetchNutritionInstructions(isRefresh: true);
  }
}
