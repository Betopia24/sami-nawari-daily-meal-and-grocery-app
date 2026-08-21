import 'package:flutter/material.dart';
import '../../../../app/widgets/custom_text_field.dart';
import '../../../../core/utils/app_assets.dart';

class ProfilePasswordField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool showVisibilityToggle;

  const ProfilePasswordField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.showVisibilityToggle = true,
  });

  @override
  State<ProfilePasswordField> createState() => _ProfilePasswordFieldState();
}

class _ProfilePasswordFieldState extends State<ProfilePasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      hint: widget.hintText,
      controller: widget.controller ?? TextEditingController(),
      prefixIcon: AppAssets.lockIcon,
      isPassword: widget.showVisibilityToggle,
      obscureText: _obscureText,
      onToggleVisibility: widget.showVisibilityToggle
          ? () {
              setState(() {
                _obscureText = !_obscureText;
              });
            }
          : null,
    );
  }
}
