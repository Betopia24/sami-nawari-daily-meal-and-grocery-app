import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/success_screen.dart';

class QuestionprefsController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentStep = 0.obs;

  // Selected answers for each step
  final RxString selectedPeople = ''.obs;
  final RxString selectedFrequency = ''.obs;
  final RxString selectedCuisine = ''.obs;
  final RxString selectedGoal = ''.obs;

  final List<Map<String, dynamic>> questions = [
    {
      'title': 'How many people do you cook for?',
      'subtitle': 'We\'ll suggest right portion sizes.',
      'crossAxisCount': 2,
      'childAspectRatio': 1.15,
      'options': [
        {
          'id': '1',
          'icon': AppAssets.personEmojiIcon,
          'title': 'Just me',
          'subtitle': '1 person',
        },
        {
          'id': '2',
          'icon': AppAssets.coupleEmojiIcon,
          'title': 'Couple',
          'subtitle': '2 people',
        },
        {
          'id': '3-4',
          'icon': AppAssets.smallFamilyEmojiIcon,
          'title': 'Small family',
          'subtitle': '3-4 people',
        },
        {
          'id': '5+',
          'icon': AppAssets.largeFamilyEmojiIcon,
          'title': 'Large family',
          'subtitle': '5 or more',
        },
      ],
      'getSelected': (QuestionprefsController c) => c.selectedPeople.value,
      'setSelected': (QuestionprefsController c, String val) =>
          c.selectedPeople.value = val,
    },
    {
      'title': 'How often do you cook?',
      'subtitle': 'Helps us build the right meal plan.',
      'crossAxisCount': 2,
      'childAspectRatio': 1.15,
      'options': [
        {
          'id': 'everyday',
          'icon': AppAssets.fireEmojiIcon,
          'title': 'Every Day',
          'subtitle': 'Daily Cooking',
        },
        {
          'id': 'few_times',
          'icon': AppAssets.calendarEmojiIcon,
          'title': 'A few times',
          'subtitle': 'Per week',
        },
        {
          'id': 'weekends',
          'icon': AppAssets.sunsetEmojiIcon,
          'title': 'Weekends',
          'subtitle': 'Weekends only',
        },
        {
          'id': 'rarely',
          'icon': AppAssets.takeoutEmojiIcon,
          'title': 'Rarely',
          'subtitle': 'Mostly takeout',
        },
      ],
      'getSelected': (QuestionprefsController c) => c.selectedFrequency.value,
      'setSelected': (QuestionprefsController c, String val) =>
          c.selectedFrequency.value = val,
    },
    {
      'title': 'Favorite cuisine?',
      'subtitle': 'Personalize your recipe feed.',
      'crossAxisCount': 2,
      'childAspectRatio': 1.15,
      'options': [
        {
          'id': 'italian',
          'icon': AppAssets.pastaEmojiIcon,
          'title': 'Italian',
          'subtitle': 'Pasta & pizza',
        },
        {
          'id': 'asian',
          'icon': AppAssets.noodlesEmojiIcon,
          'title': 'Asian',
          'subtitle': 'Noodles & rice',
        },
        {
          'id': 'mediterranean',
          'icon': AppAssets.oliveEmojiIcon,
          'title': 'Mediterranean',
          'subtitle': 'Fresh & healthy',
        },
        {
          'id': 'american',
          'icon': AppAssets.burgerEmojiIcon,
          'title': 'American',
          'subtitle': 'Comfort food',
        },
        {
          'id': 'indian',
          'icon': AppAssets.curryEmojiIcon,
          'title': 'Indian',
          'subtitle': 'Spices & curries',
        },
        {
          'id': 'mexican',
          'icon': AppAssets.tacoEmojiIcon,
          'title': 'Mexican',
          'subtitle': 'Bold & vibrant',
        },
      ],
      'getSelected': (QuestionprefsController c) => c.selectedCuisine.value,
      'setSelected': (QuestionprefsController c, String val) =>
          c.selectedCuisine.value = val,
    },
    {
      'title': 'What\'s your primary goal?',
      'subtitle': 'We\'ll tailor everything for you.',
      'crossAxisCount': 2,
      'childAspectRatio': 1.15,
      'options': [
        {
          'id': 'healthy',
          'icon': AppAssets.saladEmojiIcon,
          'title': 'Healthy Eating',
          'subtitle': 'Balanced nutrition',
        },
        {
          'id': 'save',
          'icon': AppAssets.moneyBagEmojiIcon,
          'title': 'Save Money',
          'subtitle': 'Budget-Friendly meals',
        },
        {
          'id': 'weight',
          'icon': AppAssets.scaleEmojiIcon,
          'title': 'Weight Loss',
          'subtitle': 'Calorie control',
        },
        {
          'id': 'quick',
          'icon': AppAssets.boltEmojiIcon,
          'title': 'Quick Meals',
          'subtitle': 'Under 30 minutes',
        },
        {
          'id': 'family',
          'icon': AppAssets.heartEmojiIcon,
          'title': 'Family Cooking',
          'subtitle': 'Everyone loves it',
        },
      ],
      'getSelected': (QuestionprefsController c) => c.selectedGoal.value,
      'setSelected': (QuestionprefsController c, String val) =>
          c.selectedGoal.value = val,
    },
  ];

  void selectOption(int stepIndex, String id) {
    questions[stepIndex]['setSelected'](this, id);

    // Auto-advance to the next step after a short delay for visual feedback
    Future.delayed(const Duration(milliseconds: 300), () {
      if (stepIndex < questions.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        finishWizard();
      }
    });
  }

  void skip() {
    if (currentStep.value < questions.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finishWizard();
    }
  }

  void finishWizard() {
    print('Wizard complete');
    Get.offAll(
      () => SuccessScreen(
        title: 'PREFERENCES',
        subtitle:
            'We have personalized your recipe feed\nbased on your choices.',
        buttonText: 'Go to Dashboard',
        onButtonPressed: () {
          Get.offAllNamed(Routes.navbar);
        },
      ),
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
