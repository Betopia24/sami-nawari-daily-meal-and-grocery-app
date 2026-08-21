import os

pages_file = 'lib/app/routes/app_pages.dart'

with open(pages_file, 'r') as f:
    content = f.read()

imports = """
import '../modules/common/auth/success/bindings/success_binding.dart';
import '../modules/common/auth/success/views/success_view.dart';
import '../modules/profilepreferences/locationaccess/bindings/locationaccess_binding.dart';
import '../modules/profilepreferences/locationaccess/views/locationaccess_view.dart';
import '../modules/profilepreferences/notificationaccess/bindings/notificationaccess_binding.dart';
import '../modules/profilepreferences/notificationaccess/views/notificationaccess_view.dart';
import '../modules/profilepreferences/foodpreferences/bindings/foodpreferences_binding.dart';
import '../modules/profilepreferences/foodpreferences/views/foodpreferences_view.dart';
import '../modules/profilepreferences/questionprefs/bindings/questionprefs_binding.dart';
import '../modules/profilepreferences/questionprefs/views/questionprefs_view.dart';
import '../modules/userprofile/systempreference/bindings/systempreference_binding.dart';
import '../modules/userprofile/systempreference/views/systempreference_view.dart';
import '../modules/userprofile/familyinvite/bindings/familyinvite_binding.dart';
import '../modules/userprofile/familyinvite/views/familyinvite_view.dart';
import '../modules/userprofile/dietarypref/bindings/dietarypref_binding.dart';
import '../modules/userprofile/dietarypref/views/dietarypref_view.dart';
import '../modules/userprofile/alergiesandintolerence/bindings/alergiesandintolerence_binding.dart';
import '../modules/userprofile/alergiesandintolerence/views/alergiesandintolerence_view.dart';
import '../modules/userprofile/helpandsupport/bindings/helpandsupport_binding.dart';
import '../modules/userprofile/helpandsupport/views/helpandsupport_view.dart';
import '../modules/userprofile/appsharing/bindings/appsharing_binding.dart';
import '../modules/userprofile/appsharing/views/appsharing_view.dart';
import '../modules/userprofile/privacypolicy/bindings/privacypolicy_binding.dart';
import '../modules/userprofile/privacypolicy/views/privacypolicy_view.dart';
import '../modules/userprofile/rateapp/bindings/rateapp_binding.dart';
import '../modules/userprofile/rateapp/views/rateapp_view.dart';
import '../modules/userprofile/termandcondition/bindings/termandcondition_binding.dart';
import '../modules/userprofile/termandcondition/views/termandcondition_view.dart';
import '../modules/userprofile/updatepassword/bindings/updatepassword_binding.dart';
import '../modules/userprofile/updatepassword/views/updatepassword_view.dart';
import '../modules/userprofile/editbuyerprofile/bindings/editbuyerprofile_binding.dart';
import '../modules/userprofile/editbuyerprofile/views/editbuyerprofile_view.dart';
import '../modules/userprofile/languageandregion/bindings/languageandregion_binding.dart';
import '../modules/userprofile/languageandregion/views/languageandregion_view.dart';
"""

routes = """
    GetPage(
      name: Routes.success,
      page: () => const SuccessView(),
      binding: SuccessBinding(),
    ),
    GetPage(
      name: Routes.locationaccess,
      page: () => const LocationaccessView(),
      binding: LocationaccessBinding(),
    ),
    GetPage(
      name: Routes.notificationaccess,
      page: () => const NotificationaccessView(),
      binding: NotificationaccessBinding(),
    ),
    GetPage(
      name: Routes.foodpreferences,
      page: () => const FoodpreferencesView(),
      binding: FoodpreferencesBinding(),
    ),
    GetPage(
      name: Routes.questionprefs,
      page: () => const QuestionprefsView(),
      binding: QuestionprefsBinding(),
    ),
    GetPage(
      name: Routes.systempreference,
      page: () => const SystempreferenceView(),
      binding: SystempreferenceBinding(),
    ),
    GetPage(
      name: Routes.familyinvite,
      page: () => const FamilyinviteView(),
      binding: FamilyinviteBinding(),
    ),
    GetPage(
      name: Routes.dietarypref,
      page: () => const DietaryprefView(),
      binding: DietaryprefBinding(),
    ),
    GetPage(
      name: Routes.alergiesandintolerence,
      page: () => const AlergiesandintolerenceView(),
      binding: AlergiesandintolerenceBinding(),
    ),
    GetPage(
      name: Routes.helpandsupport,
      page: () => const HelpandsupportView(),
      binding: HelpandsupportBinding(),
    ),
    GetPage(
      name: Routes.privacypolicy,
      page: () => const PrivacypolicyView(),
      binding: PrivacypolicyBinding(),
    ),
    GetPage(
      name: Routes.rateapp,
      page: () => const RateappView(),
      binding: RateappBinding(),
    ),
    GetPage(
      name: Routes.termandcondition,
      page: () => const TermandconditionView(),
      binding: TermandconditionBinding(),
    ),
    GetPage(
      name: Routes.appsharing,
      page: () => const AppsharingView(),
      binding: AppsharingBinding(),
    ),
    GetPage(
      name: Routes.updatepassword,
      page: () => const UpdatepasswordView(),
      binding: UpdatepasswordBinding(),
    ),
    GetPage(
      name: Routes.editbuyerprofile,
      page: () => const EditbuyerprofileView(),
      binding: EditbuyerprofileBinding(),
    ),
    GetPage(
      name: Routes.languageandregion,
      page: () => const LanguageandregionView(),
      binding: LanguageandregionBinding(),
    ),
"""

if 'import \'../modules/common/auth/success/bindings/success_binding.dart\';' not in content:
    content = content.replace("import 'app_routes.dart';", imports.strip() + "\nimport 'app_routes.dart';")

if 'name: Routes.success' not in content:
    content = content.replace('  ];\n}', routes.rstrip() + '\n  ];\n}')

with open(pages_file, 'w') as f:
    f.write(content)
