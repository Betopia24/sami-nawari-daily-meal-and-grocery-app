class NutritionInstructionModel {
  final String id;
  final String title;
  final String subtitle;
  final String aiInsight;
  final List<String> whyThisPlanItems;
  final List<String> focusItems;
  final List<String> foodsToEat;
  final List<String> foodsToAvoid;

  NutritionInstructionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.aiInsight,
    required this.whyThisPlanItems,
    required this.focusItems,
    required this.foodsToEat,
    required this.foodsToAvoid,
  });

  static NutritionInstructionModel getInstructionForGoal(String title) {
    switch (title) {
      case 'Weight Loss':
        return NutritionInstructionModel(
          id: 'weight_loss',
          title: 'Weight Loss',
          subtitle: 'Sustainable, not extreme',
          aiInsight:
              'Healthy weight loss is about consistent, small caloric deficits — not extreme restriction. Focus on whole, filling foods that naturally reduce calorie intake while keeping you energized.',
          whyThisPlanItems: [
            'Balanced meals across the day',
            'Protein in every main meal',
            'Rich in vegetables and fiber',
            'Supports your personal goal'
          ],
          focusItems: [
            'Drink at least 8 glasses of water',
            'Include protein with every main meal',
            'Eat vegetables with lunch & dinner',
            'Choose whole grains where possible'
          ],
          foodsToEat: [
            'Leafy Greens',
            'Berries',
            'Lean Protein',
            'Greek Yogurt',
            'Lentils',
            'Whole Grains',
            'Legumes & Beans'
          ],
          foodsToAvoid: [
            'Sugar Drinks & Sodas',
            'Refined Snacks',
            'Refined White Bread',
            'Alcohol',
            'Late Heavy Meals'
          ],
        );
      case 'Weight Gain':
        return NutritionInstructionModel(
          id: 'weight_gain',
          title: 'Weight Gain',
          subtitle: 'Build, don\'t just eat more',
          aiInsight:
              'Healthy weight gain focuses on building muscle mass through nutrient-dense, calorie-rich foods paired with resistance exercise — not simply consuming junk food.',
          whyThisPlanItems: [
            'Caloric surplus with nutrient-dense foods',
            'Protein for muscle synthesis',
            'Supports healthy weight gain'
          ],
          focusItems: [
            'Eat 5-6 meals per day',
            'Resistance training 3-4 time/week',
            'Sleep 8 hours for muscle repair',
            'Protein with very meal',
            'Post-workout nutrition within 30min',
          ],
          foodsToEat: [
            'Nuts & Nut Butter',
            'Whole Milk & Cheese',
            'Bananas',
            'Avocado',
            'Eggs',
            'Brown Rice & Oats'
          ],
          foodsToAvoid: [
            'Skipping Meals',
            'Low-Fat Products',
            'Fried Fast Food',
            'Diet Sodas & Zero-Cal Drinks'
          ],
        );
      case 'Foods for Children':
        return NutritionInstructionModel(
          id: 'foods_for_children',
          title: 'Foods for Children',
          subtitle: 'Build Strong Foundation',
          aiInsight:
              'Children\'s nutritional needs differ from adults. They need more of certain nutrients for growth and development. The goal is building healthy habits that last a lifetime.',
          whyThisPlanItems: [
            'Provides essential nutrients for growth',
            'Supports cognitive development',
            'Establishes healthy eating habits'
          ],
          focusItems: [
            'Breakfast every morning',
            'Milk or yogurt daily',
            'Limit screen time during meals',
            'Active play 60 min/day',
            'Regular meal times',
          ],
          foodsToEat: [
            'Whole Milk & Dairy',
            'Oily Fish',
            'Eggs',
            'Whole Grain Bread',
            'Fresh Fruit',
            'Colorful Vegetables'
          ],
          foodsToAvoid: [
            'Sugary Drinks & Juice',
            'Energy Drinks',
            'High-Sodium Snacks',
            'Ultra-Processed Foods'
          ],
        );
      case 'Foods for Mother':
        return NutritionInstructionModel(
          id: 'foods_for_mother',
          title: 'Foods for Mother',
          subtitle: 'Nourish yourself, Nourish your child',
          aiInsight:
              'Pregnant and nursing mothers have significantly increased nutritional needs. The right foods support fetal development, maternal health, and milk production.',
          whyThisPlanItems: [
            'Supports fetal and infant development',
            'Maintains maternal health and energy',
            'Provides essential vitamins and minerals'
          ],
          focusItems: [
            'Prenatal vitamin daily',
            'Stay hydrated',
            'Small frequent meals',
            'Gentle exercise',
            'Rest & sleep prioritized',
          ],
          foodsToEat: [
            'Folate-rich Foods',
            'Iron-rich Foods',
            'Oily Fish',
            'Whole Grains',
            'Nuts & Seeds',
            'Dairy or Fortified Alternatives'
          ],
          foodsToAvoid: [
            'Raw Fish & Undercooked Meat',
            'Alcohol',
            'High Mercury Fish',
            'Excess Caffeine'
          ],
        );
      case 'Food for Teenagers':
        return NutritionInstructionModel(
          id: 'food_for_teenagers',
          title: 'Foods for Teenagers',
          subtitle: 'Energy for growth spurts',
          aiInsight:
              'Teenagers are in a period of rapid growth and high energy expenditure. They need more calcium, iron, and protein than younger children and many adults.',
          whyThisPlanItems: [
            'Fuels rapid growth and development',
            'Supports bone health and density',
            'Provides energy for active lifestyles'
          ],
          focusItems: [
            'Breakfast everyday',
            'Active lifestyle',
            'Limit energy drinks',
            'Sleep 8-9 hours',
            'Regular meals, not skipping',
          ],
          foodsToEat: [
            'Dairy',
            'Iron-rich Foods',
            'Eggs',
            'Whole Grain Foods',
            'Nuts & Seeds',
            'Fruits & Vegetables'
          ],
          foodsToAvoid: [
            'Skipping Meals',
            'Energy Drinks',
            'Fast food as a daily habit',
            'Excess Caffeine'
          ],
        );
      case 'Healthy Lifestyle':
        return NutritionInstructionModel(
          id: 'healthy_lifestyle',
          title: 'Healthy Lifestyle',
          subtitle: 'Balance is the foundation',
          aiInsight:
              'A healthy lifestyle is not about perfection — it\'s about consistent, sustainable habits. Focus on variety, moderation, and listening to your body\'s signals.',
          whyThisPlanItems: [
            'Promotes long-term health and wellbeing',
            'Reduces risk of chronic diseases',
            'Improves energy levels and mood'
          ],
          focusItems: [
            '5 Fruits & Vegetables',
            '30 min of movement',
            'Limit processed foods',
            'Social meals with family',
            'Regular meal time',
          ],
          foodsToEat: [
            'Olive Oil',
            'Rainbow Vegetables',
            'Fatty Fish',
            'Fresh Fruits',
            'Legumes',
            'Water'
          ],
          foodsToAvoid: [
            'Processed Meats',
            'High Sugar Cereals',
            'Fried Fast Food',
            'Excess Sodium'
          ],
        );
      default:
        // Fallback for unknown
        return NutritionInstructionModel(
          id: 'unknown',
          title: title,
          subtitle: 'General Nutrition',
          aiInsight: 'Focus on balanced and healthy eating habits.',
          whyThisPlanItems: ['Balanced nutrition', 'Sustainable lifestyle'],
          focusItems: ['Drink water', 'Stay active'],
          foodsToEat: ['Vegetables', 'Fruits', 'Lean Protein'],
          foodsToAvoid: ['Junk food', 'Excess Sugar'],
        );
    }
  }
}
