import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/utils/app_colors.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final String? hintText;
  final bool showBottomDivider;
  final Widget? trailing;
  final Widget? customInput;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;

  const ProfileTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.hintText,
    this.showBottomDivider = true,
    this.trailing,
    this.customInput,
    this.controller,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (controller != null ||
                        initialValue != null ||
                        hintText != null)
                      TextFormField(
                        controller: controller,
                        initialValue: controller == null ? initialValue : null,
                        readOnly: readOnly,
                        onTap: onTap,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                          ),
                        ),
                      ),
                    if (customInput != null) ...[
                      const SizedBox(height: 8),
                      customInput!,
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 16),
                onTap != null
                    ? GestureDetector(
                        onTap: onTap,
                        behavior: HitTestBehavior.opaque,
                        child: trailing!,
                      )
                    : trailing!,
              ],
            ],
          ),
        ),
        if (showBottomDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.withValues(alpha: 0.15),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
