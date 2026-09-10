import 'package:get/get.dart';

class ChooseyourplanController extends GetxController {
  final RxBool isYearly = false.obs;

  void togglePlan(bool yearly) {
    isYearly.value = yearly;
  }
}
