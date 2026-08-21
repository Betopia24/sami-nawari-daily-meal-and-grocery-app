import 'package:get/get.dart';
import '../controllers/languageandregion_controller.dart';

class LanguageandregionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageandregionController>(
      () => LanguageandregionController(),
    );
  }
}
