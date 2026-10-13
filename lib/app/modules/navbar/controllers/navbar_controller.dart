import 'package:get/get.dart';

class NavbarController extends GetxController {
  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map && Get.arguments['tab'] != null) {
      _currentIndex.value = Get.arguments['tab'];
    }
  }

  void changePage(int index) {
    _currentIndex.value = index;
  }
}
