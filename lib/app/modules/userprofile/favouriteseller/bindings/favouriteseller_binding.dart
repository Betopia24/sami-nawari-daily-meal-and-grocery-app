import 'package:get/get.dart';
import '../controllers/favouriteseller_controller.dart';

class FavouritesellerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavouritesellerController>(() => FavouritesellerController());
  }
}
