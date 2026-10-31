import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color iconColor;
  final bool hasBorder;

  const CustomBackButton({
    super.key,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: InkWell(
        onTap: onTap ??
            () {
              if (Navigator.of(context).canPop()) {
                Get.back();
              } else {
                Get.offAllNamed(Routes.navbar);
              }
            },
        borderRadius: BorderRadius.circular(16),
        child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: hasBorder
              ? Border.all(color: Colors.grey.withValues(alpha: 0.2))
              : null,
        ),
        child: Center(
          child: Icon(Icons.chevron_left, color: iconColor, size: 24),
        ),
        ),
      ),
    );
  }
}
