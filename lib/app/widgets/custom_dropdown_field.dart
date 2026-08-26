import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/app_colors.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final String? hintText;
  final bool isRequired;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    this.hintText,
    this.isRequired = false,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: '*',
                      style: GoogleFonts.outfit(
                        color: AppColors.error,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        PopupMenuButton<T>(
          initialValue: value,
          onSelected: onChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          itemBuilder: (context) {
            return items.map((item) {
              return PopupMenuItem<T>(
                value: item.value,
                child: item.child,
              );
            }).toList();
          },
          child: InputDecorator(
            decoration: InputDecoration(
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _getSelectedChild() ?? (hintText != null 
                    ? Text(hintText!, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 16))
                    : const SizedBox.shrink()),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget? _getSelectedChild() {
    if (value == null) return null;
    for (var item in items) {
      if (item.value == value) {
        return item.child;
      }
    }
    return null;
  }
}
