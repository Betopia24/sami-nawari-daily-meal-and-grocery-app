import 'package:get/get.dart';
import '../modules/common/splash/bindings/splash_binding.dart';
import '../modules/common/splash/views/splash_view.dart';
import '../modules/common/onboarding/bindings/onboarding_binding.dart';
import '../modules/common/onboarding/views/onboarding_view.dart';
import '../modules/common/auth/welcomeauth/bindings/welcomeauth_binding.dart';
import '../modules/common/auth/welcomeauth/views/welcomeauth_view.dart';
import '../modules/common/auth/signup/bindings/signup_binding.dart';
import '../modules/common/auth/signup/views/signup_view.dart';
import '../modules/common/auth/signin/bindings/signin_binding.dart';
import '../modules/common/auth/signin/views/signin_view.dart';
import '../modules/common/auth/forgotpassword/bindings/forgotpassword_binding.dart';
import '../modules/common/auth/forgotpassword/views/forgotpassword_view.dart';
import '../modules/common/auth/otp/bindings/otp_binding.dart';
import '../modules/common/auth/otp/views/otp_view.dart';
import '../modules/common/auth/resetpassword/bindings/resetpassword_binding.dart';
import '../modules/common/auth/resetpassword/views/resetpassword_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/foodgrid/recommendedfoodgrid/bindings/recommendedfood_binding.dart';
import '../modules/foodgrid/recommendedfoodgrid/views/recommendedfood_view.dart';
import '../modules/foodgrid/homemadefoodgrid/bindings/homemadefoodgrid_binding.dart';
import '../modules/foodgrid/homemadefoodgrid/views/homemadefoodgrid_view.dart';
import '../modules/foodgrid/fooddetails/bindings/fooddetails_binding.dart';
import '../modules/foodgrid/fooddetails/views/fooddetails_view.dart';
import '../modules/receipes/breakfastreceipes/bindings/breakfastreceipes_binding.dart';
import '../modules/receipes/breakfastreceipes/views/breakfastreceipes_view.dart';
import '../modules/receipes/lunchreceipes/bindings/lunchreceipes_binding.dart';
import '../modules/receipes/lunchreceipes/views/lunchreceipes_view.dart';
import '../modules/receipes/dinnerreceipes/bindings/dinnerreceipes_binding.dart';
import '../modules/receipes/dinnerreceipes/views/dinnerreceipes_view.dart';
import '../modules/receipes/receipedetails/bindings/receipedetails_binding.dart';
import '../modules/receipes/receipedetails/views/receipedetails_view.dart';
import '../modules/receipes/snacksreceipes/bindings/snacksreceipes_binding.dart';
import '../modules/receipes/snacksreceipes/views/snacksreceipes_view.dart';
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
import '../modules/userprofile/orderhistory/bindings/orderhistory_binding.dart';
import '../modules/userprofile/orderhistory/views/orderhistory_view.dart';
import '../modules/userprofile/savedreceipe/bindings/savedreceipe_binding.dart';
import '../modules/userprofile/savedreceipe/views/savedreceipe_view.dart';
import '../modules/userprofile/favouriteseller/bindings/favouriteseller_binding.dart';
import '../modules/userprofile/favouriteseller/views/favouriteseller_view.dart';
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
import '../modules/cart/mycarts/bindings/mycarts_binding.dart';
import '../modules/cart/mycarts/views/mycarts_view.dart';
import '../modules/cart/revieworder/bindings/revieworder_binding.dart';
import '../modules/cart/revieworder/views/revieworder_view.dart';

import '../modules/cart/deliveryselection/bindings/deliveryselection_binding.dart';
import '../modules/cart/deliveryselection/views/deliveryselection_view.dart';
import '../modules/cart/deliveryaddress/bindings/deliveryaddress_binding.dart';
import '../modules/cart/deliveryaddress/views/deliveryaddress_view.dart';
import '../modules/cart/placeorder/bindings/placeorder_binding.dart';
import '../modules/cart/placeorder/views/placeorder_view.dart';
import '../modules/cart/orderplaced/bindings/orderplaced_binding.dart';
import '../modules/cart/orderplaced/views/orderplaced_view.dart';
import '../modules/groceries/sharedmembers/bindings/shared_members_binding.dart';
import '../modules/groceries/sharedmembers/views/shared_members_view.dart';
import '../modules/groceries/memberinvite/bindings/member_invite_binding.dart';
import '../modules/groceries/memberinvite/views/member_invite_view.dart';
import '../modules/groceries/permissionset/bindings/permissionset_binding.dart';
import '../modules/groceries/permissionset/views/permissionset_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.navbar;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.welcomeauth,
      page: () => const WelcomeauthView(),
      binding: WelcomeauthBinding(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: Routes.signin,
      page: () => const SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: Routes.forgotpassword,
      page: () => const ForgotpasswordView(),
      binding: ForgotpasswordBinding(),
    ),
    GetPage(
      name: Routes.otp,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: Routes.resetpassword,
      page: () => const ResetpasswordView(),
      binding: ResetpasswordBinding(),
    ),
    GetPage(
      name: Routes.navbar,
      page: () => const NavbarView(),
      binding: NavbarBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.recommendedfood,
      page: () => const RecommendedfoodView(),
      binding: RecommendedfoodBinding(),
    ),
    GetPage(
      name: Routes.homemadefoodgrid,
      page: () => const HomemadefoodgridView(),
      binding: HomemadefoodgridBinding(),
    ),
    GetPage(
      name: Routes.fooddetails,
      page: () => const FooddetailsView(),
      binding: FooddetailsBinding(),
    ),
    GetPage(
      name: Routes.breakfastreceipes,
      page: () => const BreakfastreceipesView(),
      binding: BreakfastreceipesBinding(),
    ),
    GetPage(
      name: Routes.lunchreceipes,
      page: () => const LunchreceipesView(),
      binding: LunchreceipesBinding(),
    ),
    GetPage(
      name: Routes.dinnerreceipes,
      page: () => const DinnerreceipesView(),
      binding: DinnerreceipesBinding(),
    ),
    GetPage(
      name: Routes.snacksreceipes,
      page: () => const SnacksreceipesView(),
      binding: SnacksreceipesBinding(),
    ),
    GetPage(
      name: Routes.receipedetails,
      page: () => const ReceipedetailsView(),
      binding: ReceipedetailsBinding(),
    ),

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
      name: Routes.orderhistory,
      page: () => const OrderhistoryView(),
      binding: OrderhistoryBinding(),
    ),
    GetPage(
      name: Routes.savedreceipe,
      page: () => const SavedreceipeView(),
      binding: SavedreceipeBinding(),
    ),
    GetPage(
      name: Routes.favouriteseller,
      page: () => const FavouritesellerView(),
      binding: FavouritesellerBinding(),
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
    GetPage(
      name: Routes.mycarts,
      page: () => const MycartsView(),
      binding: MycartsBinding(),
    ),
    GetPage(
      name: Routes.revieworder,
      page: () => const RevieworderView(),
      binding: RevieworderBinding(),
    ),
    GetPage(
      name: Routes.deliveryselection,
      page: () => const DeliveryselectionView(),
      binding: DeliveryselectionBinding(),
    ),
    GetPage(
      name: Routes.deliveryaddress,
      page: () => const DeliveryaddressView(),
      binding: DeliveryaddressBinding(),
    ),
    GetPage(
      name: Routes.placeorder,
      page: () => const PlaceorderView(),
      binding: PlaceorderBinding(),
    ),
    GetPage(
      name: Routes.orderplaced,
      page: () => const OrderplacedView(),
      binding: OrderplacedBinding(),
    ),
    GetPage(
      name: Routes.sharedmembers,
      page: () => const SharedMembersView(),
      binding: SharedMembersBinding(),
    ),
    GetPage(
      name: Routes.MEMBERINVITE,
      page: () => const MemberInviteView(),
      binding: MemberInviteBinding(),
    ),
    GetPage(
      name: Routes.PERMISSIONSET,
      page: () => const PermissionSetView(),
      binding: PermissionSetBinding(),
    ),
  ];
}
