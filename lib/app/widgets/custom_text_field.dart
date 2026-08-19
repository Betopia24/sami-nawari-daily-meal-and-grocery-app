import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final String prefixIcon;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  bool _hasLostFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (!_hasLostFocus) {
          setState(() {
            _hasLostFocus = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: _fieldKey,
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          focusNode: _focusNode,
          autovalidateMode: _hasLostFocus 
              ? AutovalidateMode.onUserInteraction 
              : AutovalidateMode.disabled,
          onChanged: (value) {
            if (_fieldKey.currentState?.hasError ?? false) {
              if (!_hasLostFocus) {
                setState(() {
                  _hasLostFocus = true;
                });
                // Force a re-validation immediately so the error clears or updates
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _fieldKey.currentState?.validate();
                });
              }
            }
          },
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                widget.prefixIcon,
                colorFilter: const ColorFilter.mode(
                  AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: widget.obscureText
                        ? const Icon(
                            Icons.visibility_off,
                            color: AppColors.textSecondary,
                            size: 20,
                          )
                        : SvgPicture.asset(
                            AppAssets.eyeIcon,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                    onPressed: widget.onToggleVisibility,
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            errorStyle: GoogleFonts.outfit(
              color: AppColors.error,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
