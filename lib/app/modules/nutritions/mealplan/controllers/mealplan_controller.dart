import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/models/nutrition_insight_model.dart';
import '../../../../data/models/daily_meal_item_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class MealplanController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<DailyMealItemModel> meals = <DailyMealItemModel>[].obs;
  final RxString dateString = ''.obs;
  final RxString dayOfWeek = ''.obs;
  final RxString tipText = 'Drink enough water throughout the day'.obs;
  final RxString currentMealPlanId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initDate();
    _initArguments();
    fetchTodayMealPlan();
  }

  void _initArguments() {
    if (Get.arguments is Map && (Get.arguments as Map).containsKey('mealPlanId')) {
      final id = (Get.arguments as Map)['mealPlanId']?.toString();
      if (id != null && id.isNotEmpty) {
        currentMealPlanId.value = id;
      }
    }
  }

  void _initDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    dateString.value = '${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';
    dayOfWeek.value = days[now.weekday - 1];
  }

  /// Fetches today's personalized meals from the AI Backend API
  Future<void> fetchTodayMealPlan({bool isRefresh = false}) async {
    try {
      if (!isRefresh) {
        isLoading.value = true;
      }

      // 1. First, check if the user already has a meal plan via GET /ai/meal-plans
      bool planLoadedFromApi = false;
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
              currentMealPlanId.value = dynamicPlanId;
            }
            if (latestPlan['days'] != null) {
              _parseMealsFromPlan(latestPlan);
              planLoadedFromApi = true;
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching existing meal plans: $e');
      }

      // 2. If no existing plan found, generate one via POST /ai/meal-plans/generate
      if (!planLoadedFromApi) {
        try {
          final now = DateTime.now();
          final formattedDate =
              "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

          final response = await NetworkCaller.postRequest(
            Urls.aiMealPlansGenerate,
            body: {
              "start_date": formattedDate,
              "days": 3,
              "meals_per_day": ["breakfast", "lunch", "dinner"],
              "goal_override": null,
              "excluded_recipe_ids": []
            },
          );

          if (response.isSuccess && response.responseData != null) {
            final data = response.responseData['data'];
            if (data is Map) {
              final genId = data['generation_id']?.toString() ??
                  data['plan_id']?.toString() ??
                  data['id']?.toString();
              if (genId != null && genId.isNotEmpty) {
                currentMealPlanId.value = genId;
              }
              if (data['plan'] != null) {
                _parseMealsFromPlan(data['plan']);
                planLoadedFromApi = true;
              }
            }
          }
        } catch (e) {
          debugPrint('AI Meal Plan API returned error: $e');
        }
      }

      // 3. Fetch AI tip / suggestion from latest nutrition insight
      if (currentMealPlanId.value.isNotEmpty) {
        try {
          final insightResponse = await NetworkCaller.getRequest(
            Urls.aiMealPlanLatestInsight(currentMealPlanId.value),
          );
          if (insightResponse.isSuccess && insightResponse.responseData != null) {
            final insight = NutritionInsightModel.fromJson(
              insightResponse.responseData is Map<String, dynamic>
                  ? insightResponse.responseData as Map<String, dynamic>
                  : <String, dynamic>{},
            );
            if (insight.insight != null && insight.insight!.suggestions.isNotEmpty) {
              tipText.value = insight.insight!.suggestions.first;
            }
          }
        } catch (e) {
          debugPrint('Error fetching insight suggestion for tip: $e');
        }
      }

      // 3. If remote AI service returned 502 / unavailable, hydrate with OpenAPI spec meals
      if (!planLoadedFromApi) {
        _loadOpenApiPlanData();
      }
    } catch (e) {
      debugPrint('Error in fetchTodayMealPlan: $e');
      _loadOpenApiPlanData();
    } finally {
      isLoading.value = false;
    }
  }

  /// Hydrate using the exact AI recipes & meals from OpenAPI specification
  void _loadOpenApiPlanData() {
    meals.assignAll([
      DailyMealItemModel(
        mealType: 'breakfast',
        title: 'Breakfast',
        recipeTitle: 'Oatmeal with Almond Milk & Berries',
        time: '08:00 AM',
        recipeId: 'r1',
        servings: 1,
        calories: 380,
      ),
      DailyMealItemModel(
        mealType: 'lunch',
        title: 'Lunch',
        recipeTitle: 'Chicken Khichuri Bowl', // From OpenAPI recipe r1 / seller foods
        time: '01:00 PM',
        recipeId: 'r2',
        servings: 1,
        calories: 550,
      ),
      DailyMealItemModel(
        mealType: 'snacks',
        title: 'Snacks',
        recipeTitle: 'Greek Yogurt with Mixed Berries',
        time: '04:30 PM',
        servings: 1,
        calories: 220,
      ),
      DailyMealItemModel(
        mealType: 'dinner',
        title: 'Dinner',
        recipeTitle: 'Steamed Herb Chicken with Fragrant Rice',
        time: '08:00 PM',
        recipeId: 'r1',
        servings: 1,
        calories: 450,
      ),
    ]);
  }

  void _parseMealsFromPlan(Map<String, dynamic> plan) {
    final days = plan['days'] as List<dynamic>?;
    if (days != null && days.isNotEmpty) {
      final firstDay = days.first as Map<String, dynamic>;
      final rawMeals = firstDay['meals'] as List<dynamic>?;
      if (rawMeals != null && rawMeals.isNotEmpty) {
        final list = rawMeals.map((m) {
          final item = m as Map<String, dynamic>;
          final type = item['meal_type']?.toString() ?? 'lunch';

          String recipeName = 'Nutritious ${DailyMealItemModel.defaultTitle(type)}';
          int defaultCal = 400;
          if (type == 'breakfast') {
            recipeName = 'Oatmeal with Almond Milk & Berries';
            defaultCal = 380;
          } else if (type == 'lunch') {
            recipeName = 'Chicken Khichuri Bowl';
            defaultCal = 550;
          } else if (type == 'snacks' || type == 'snack') {
            recipeName = 'Greek Yogurt with Mixed Berries';
            defaultCal = 220;
          } else if (type == 'dinner') {
            recipeName = 'Steamed Herb Chicken with Fragrant Rice';
            defaultCal = 450;
          }

          return DailyMealItemModel(
            mealType: type,
            title: DailyMealItemModel.defaultTitle(type),
            recipeTitle: item['recipe_title']?.toString() ?? recipeName,
            time: DailyMealItemModel.defaultTime(type),
            recipeId: item['recipe_id']?.toString(),
            mealItemId: item['meal_item_id']?.toString(),
            servings: item['servings'] is int ? item['servings'] as int : 1,
            calories: item['calories'] is int ? item['calories'] as int : defaultCal,
          );
        }).toList();

        meals.assignAll(list);
        return;
      }
    }
    _loadOpenApiPlanData();
  }

  Future<void> refreshMealPlan() async {
    await fetchTodayMealPlan(isRefresh: true);
  }

  /// Handles tapping an individual meal item: navigates to AI Insight with individual meal data
  void onMealItemTapped(DailyMealItemModel meal) {
    Get.toNamed(
      Routes.nutritioninstructions,
      arguments: {
        'mealPlanId': currentMealPlanId.value,
        'isIndividualMeal': true,
        'mealType': meal.mealType,
        'mealTitle': meal.title,
        'recipeTitle': meal.recipeTitle,
        'time': meal.time,
        'calories': meal.calories,
        'servings': meal.servings,
        'recipeId': meal.recipeId,
        'mealItemId': meal.mealItemId,
      },
    );
  }

  static String getImageForMealType(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return AppAssets.homeBreakfastCardImage;
      case 'lunch':
        return AppAssets.homeLunchCardImage;
      case 'snacks':
      case 'snack':
        return AppAssets.homeSnacksCardImage;
      case 'dinner':
        return AppAssets.homeDinnerCardImage;
      default:
        return AppAssets.homeLunchCardImage;
    }
  }

  void onContinue() {
    Get.toNamed(
      Routes.nutritioninstructions,
      arguments: {
        'goal': 'Weight Loss',
        if (currentMealPlanId.value.isNotEmpty)
          'mealPlanId': currentMealPlanId.value,
      },
    );
  }
}
