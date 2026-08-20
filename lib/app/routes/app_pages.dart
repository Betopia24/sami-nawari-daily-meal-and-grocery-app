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
  ];
}
