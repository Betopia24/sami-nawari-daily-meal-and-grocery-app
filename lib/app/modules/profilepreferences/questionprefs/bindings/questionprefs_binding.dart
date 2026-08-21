import 'package:get/get.dart';
import '../controllers/questionprefs_controller.dart';

class QuestionprefsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionprefsController>(() => QuestionprefsController());
  }
}
