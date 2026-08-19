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
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.welcomeauth;

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
  ];
}
