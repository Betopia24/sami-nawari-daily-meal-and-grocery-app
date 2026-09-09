import 'package:get/get.dart';

class InspirationmealdetailsController extends GetxController {
  final activeTab = 0.obs;
  final servings = 2.obs;

  void switchTab(int index) {
    activeTab.value = index;
  }

  void incrementServings() {
    servings.value++;
  }

  void decrementServings() {
    if (servings.value > 1) servings.value--;
  }

  final String description = 'A rich and creamy pasta with fresh tomatoes, garlic and a hint of basil.';

  final List<Map<String, String>> ingredients = [
    {'name': 'Pasta', 'amount': '1 packet', 'icon': 'assets/emojis/pasta_emoji.png'},
    {'name': 'Cherry tomatoes', 'amount': '6 pieces', 'icon': 'assets/emojis/olive_emoji.png'},
    {'name': 'Coconut Milk', 'amount': '1L', 'icon': 'assets/emojis/olive_emoji.png'},
  ];

  final List<Map<String, String>> methodSteps = [
    {
      'title': 'Toast the bread',
      'description': 'Toast sourdough bread until golden and crispy on both sides. A good toast should have crunch but still be chewy inside.',
    },
    {
      'title': 'Mash the avocado',
      'description': 'Halve the avocado and scoop into a bowl. Add lemon juice, a pinch of salt, and red pepper flakes. Mash with a fork — keep it slightly chunky for texture.',
    },
    {
      'title': 'Prepare for poaching',
      'description': 'Bring 3 inches of water to a gentle simmer in a wide saucepan. Add a small splash of white vinegar — this helps the egg white hold together.',
    },
    {
      'title': 'Poach the eggs',
      'description': 'Crack each egg into a small cup. Create a gentle whirlpool with a spoon, then slide the egg gently into the center. Cook 3 minutes for a runny yolk.',
    },
    {
      'title': 'Assemble',
      'description': 'Spread avocado mixture generously over the toast. Use a slotted spoon to lift the egg out and blot with a paper towel, then place on top.',
    },
    {
      'title': 'Garnish & Serve',
      'description': 'Top with halved cherry tomatoes, snipped chives, and a pinch of flaky sea salt. Serve immediately.',
    }
  ];

  final RxSet<int> completedSteps = <int>{0}.obs; // Matches screenshot where step 1 is done

  void toggleStep(int index) {
    if (completedSteps.contains(index)) {
      completedSteps.remove(index);
    } else {
      completedSteps.add(index);
    }
  }

  final List<String> proTips = [
    'Use the freshest eggs possible — older eggs spread more in water.',
    'Add a drop of white vinegar to the poaching water to keep the whites together.',
    'For perfectly ripe avocado: the skin should yield slightly when pressed.',
    'Toast the bread just before serving so it stays crispy.',
  ];
}
