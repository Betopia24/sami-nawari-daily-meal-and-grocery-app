import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/splash_controller.dart';
import '../../../../../core/utils/app_assets.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.5 + (value * 0.5), // Scale from 0.5 to 1.0
              child: Opacity(
                opacity: value.clamp(0.0, 1.0), // Fade in from 0 to 1
                child: child,
              ),
            );
          },
          child: Image.asset(
            AppAssets.titledLogoVerticalGreenGrayPng,
            width: 150.w,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
