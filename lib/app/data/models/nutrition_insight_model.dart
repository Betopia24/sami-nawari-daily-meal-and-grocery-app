/// Model representing the AI Nutrition Insight response from OpenAPI spec:
/// `/internal/v1/meal-plans/{meal_plan_id}/insights/latest`
class NutritionInsightModel {
  final String? requestId;
  final String? generationId;
  final NutritionMacronutrients? nutrition;
  final NutritionInsightContent? insight;
  final bool cached;

  NutritionInsightModel({
    this.requestId,
    this.generationId,
    this.nutrition,
    this.insight,
    this.cached = false,
  });

  factory NutritionInsightModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;

    return NutritionInsightModel(
      requestId: json['request_id'] as String?,
      generationId: data['generation_id'] as String?,
      nutrition: data['nutrition'] != null
          ? NutritionMacronutrients.fromJson(data['nutrition'] as Map<String, dynamic>)
          : null,
      insight: data['insight'] != null
          ? NutritionInsightContent.fromJson(data['insight'] as Map<String, dynamic>)
          : null,
      cached: (json['meta'] is Map && json['meta']['cached'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (requestId != null) 'request_id': requestId,
      'data': {
        if (generationId != null) 'generation_id': generationId,
        if (nutrition != null) 'nutrition': nutrition!.toJson(),
        if (insight != null) 'insight': insight!.toJson(),
      },
      'meta': {
        'cached': cached,
      },
    };
  }
}

class NutritionMacronutrients {
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int fiberG;
  final int sugarG;
  final int sodiumMg;

  NutritionMacronutrients({
    this.calories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    this.fiberG = 0,
    this.sugarG = 0,
    this.sodiumMg = 0,
  });

  factory NutritionMacronutrients.fromJson(Map<String, dynamic> json) {
    return NutritionMacronutrients(
      calories: _toInt(json['calories']),
      proteinG: _toInt(json['protein_g']),
      carbsG: _toInt(json['carbs_g']),
      fatG: _toInt(json['fat_g']),
      fiberG: _toInt(json['fiber_g']),
      sugarG: _toInt(json['sugar_g']),
      sodiumMg: _toInt(json['sodium_mg']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'fiber_g': fiberG,
      'sugar_g': sugarG,
      'sodium_mg': sodiumMg,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class NutritionInsightContent {
  final String summary;
  final List<String> positivePoints;
  final List<String> suggestions;

  NutritionInsightContent({
    this.summary = '',
    this.positivePoints = const [],
    this.suggestions = const [],
  });

  factory NutritionInsightContent.fromJson(Map<String, dynamic> json) {
    return NutritionInsightContent(
      summary: json['summary']?.toString() ?? '',
      positivePoints: (json['positive_points'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'positive_points': positivePoints,
      'suggestions': suggestions,
    };
  }
}
