import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';

class ReceipedetailsController extends GetxController {
  final activeTab = 0.obs; // 0: Ingredients, 1: Method
  final servings = 2.obs;
  final completedSteps = <int>{}.obs;

  void switchTab(int index) {
    activeTab.value = index;
  }

  void incrementServings() {
    servings.value++;
  }

  void decrementServings() {
    if (servings.value > 1) {
      servings.value--;
    }
  }

  void toggleStep(int stepIndex) {
    if (completedSteps.contains(stepIndex)) {
      completedSteps.remove(stepIndex);
    } else {
      completedSteps.add(stepIndex);
    }
  }

  final ingredients = [
    {
      'icon': AppAssets.logoCropped,
      'name': 'Sourdough bread',
      'amount': '2 slices',
    },
    {
      'icon': AppAssets.logoCropped,
      'name': 'Ripe avocado',
      'amount': '1 large',
    },
    {'icon': AppAssets.logoCropped, 'name': 'Eggs', 'amount': '2 large'},
    {
      'icon': AppAssets.logoCropped,
      'name': 'Cherry tomatoes',
      'amount': '6 pieces',
    },
    {'icon': AppAssets.logoCropped, 'name': 'Lemon juice', 'amount': '1 tbsp'},
    {
      'icon': AppAssets.logoCropped,
      'name': 'Red pepper flakes',
      'amount': '½ tsp',
    },
    {'icon': AppAssets.logoCropped, 'name': 'Sea salt', 'amount': '¼ tsp'},
    {'icon': AppAssets.logoCropped, 'name': 'Fresh chives', 'amount': '1 tbsp'},
  ];

  final methodSteps = [
    {
      'title': 'Toast the bread',
      'description':
          'Toast sourdough bread until golden and crispy on both sides. A good toast should have crunch but still be chewy inside.',
    },
    {
      'title': 'Mash the avocado',
      'description':
          'Halve the avocado and scoop into a bowl. Add lemon juice, a pinch of salt, and red pepper flakes. Mash with a fork — keep it slightly chunky for texture.',
    },
    {
      'title': 'Prepare for poaching',
      'description':
          'Bring 3 inches of water to a gentle simmer in a wide saucepan. Add a small splash of white vinegar — this helps the egg white hold together.',
    },
    {
      'title': 'Poach the eggs',
      'description':
          'Crack each egg into a small cup. Create a gentle whirlpool with a spoon, then slide the egg gently into the center. Cook 3 minutes for a runny yolk.',
    },
    {
      'title': 'Assemble',
      'description':
          'Spread avocado mixture generously over the toast. Use a slotted spoon to lift the egg out and blot with a paper towel, then place on top.',
    },
    {
      'title': 'Garnish & Serve',
      'description':
          'Top with halved cherry tomatoes, snipped chives, and a pinch of flaky sea salt. Serve immediately.',
    },
  ];

  final proTips = [
    'Use the freshest eggs possible — older eggs spread more in water.',
    'Add a drop of white vinegar to the poaching water to keep the whites together.',
    'For perfectly ripe avocado: the skin should yield slightly when pressed.',
    'Toast the bread just before serving so it stays crispy.',
  ];
}
