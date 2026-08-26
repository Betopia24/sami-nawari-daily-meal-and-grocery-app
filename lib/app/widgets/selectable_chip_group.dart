import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/app_colors.dart';

class SelectableChipGroup extends StatefulWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onChanged;

  const SelectableChipGroup({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
  });

  @override
  State<SelectableChipGroup> createState() => _SelectableChipGroupState();
}

class _SelectableChipGroupState extends State<SelectableChipGroup> {
  void _toggleSelection(String option) {
    final List<String> currentSelections = List.from(widget.selectedOptions);
    if (currentSelections.contains(option)) {
      currentSelections.remove(option);
    } else {
      currentSelections.add(option);
    }
    widget.onChanged(currentSelections);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.options.map((option) {
        final isSelected = widget.selectedOptions.contains(option);
        return InkWell(
          onTap: () => _toggleSelection(option),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: Text(
              option,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
