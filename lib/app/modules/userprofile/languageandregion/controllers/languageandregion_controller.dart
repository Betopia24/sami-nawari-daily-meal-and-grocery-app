import 'package:get/get.dart';

class LanguageandregionController extends GetxController {
  final RxString language = 'Select your language'.obs;
  final RxString country = 'Select your country'.obs;
  final RxString timeZone = 'Select your time zone'.obs;

  final RxString dateFormat = 'MM/DD/YYYY'.obs;
  final RxString timeFormat = '12-hour (3:30 PM)'.obs;
  final RxString units = 'Imperial (lb, oz, °F)'.obs;
  final RxString currency = 'USD (\$)'.obs;

  void setLanguage(String value) => language.value = value;
  void setCountry(String value) => country.value = value;
  void setTimeZone(String value) => timeZone.value = value;

  void setDateFormat(String value) => dateFormat.value = value;
  void setTimeFormat(String value) => timeFormat.value = value;
  void setUnits(String value) => units.value = value;
  void setCurrency(String value) => currency.value = value;

  void saveChanges() {
    Get.back();
  }
}
