import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/app_colors.dart';

class CustomTimeDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomTimeDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  /// Helper to convert 24-hour time like "09:00" or "18:00" to 12-hour format "09:00 AM", "06:00 PM"
  static String formatTo12Hour(String time) {
    final trimmed = time.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'closed') return 'Closed';
    if (trimmed.toUpperCase().contains('AM') || trimmed.toUpperCase().contains('PM')) {
      return trimmed;
    }
    final parts = trimmed.split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1].substring(0, 2));
      if (hour != null && minute != null) {
        final period = hour >= 12 ? 'PM' : 'AM';
        final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
        final hourStr = h.toString().padLeft(2, '0');
        final minStr = minute.toString().padLeft(2, '0');
        return '$hourStr:$minStr $period';
      }
    }
    return trimmed;
  }

  /// Helper to normalize any time string ("09:00", "9:00 AM", "09:00 AM") for comparison
  static String _canonicalTime(String t) {
    final trimmed = t.trim().toUpperCase();
    if (trimmed.isEmpty || trimmed == 'CLOSED') return 'CLOSED';

    final regex12 = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$', caseSensitive: false);
    final match12 = regex12.firstMatch(trimmed);
    if (match12 != null) {
      final h = int.parse(match12.group(1)!);
      final m = match12.group(2)!;
      final period = match12.group(3)!.toUpperCase();
      return '$h:$m $period';
    }

    final regex24 = RegExp(r'^(\d{1,2}):(\d{2})$');
    final match24 = regex24.firstMatch(trimmed);
    if (match24 != null) {
      final hour = int.parse(match24.group(1)!);
      final m = match24.group(2)!;
      final period = hour >= 12 ? 'PM' : 'AM';
      final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$h:$m $period';
    }
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Deduplicate items list
    final uniqueItems = <String>[];
    for (final item in items) {
      if (!uniqueItems.contains(item)) {
        uniqueItems.add(item);
      }
    }

    // 2. Resolve matching value (handling null, 24h to 12h format or missing entries)
    String resolvedValue =
        value ?? (uniqueItems.isNotEmpty ? uniqueItems.first : 'Closed');
    if (resolvedValue.isEmpty && uniqueItems.isNotEmpty) {
      resolvedValue = uniqueItems.first;
    }

    // Try exact match first
    if (!uniqueItems.contains(resolvedValue)) {
      // Try canonical / normalized match against existing items in uniqueItems
      final targetCanonical = _canonicalTime(resolvedValue);
      final canonicalIndex = uniqueItems.indexWhere(
        (item) => _canonicalTime(item) == targetCanonical,
      );

      if (canonicalIndex != -1) {
        resolvedValue = uniqueItems[canonicalIndex];
      } else {
        // Try case-insensitive trimmed match
        final matchIndex = uniqueItems.indexWhere(
          (item) =>
              item.trim().toLowerCase() == resolvedValue.trim().toLowerCase(),
        );
        if (matchIndex != -1) {
          resolvedValue = uniqueItems[matchIndex];
        } else {
          // If still not found, convert to 12-hour format or keep as-is, and insert into uniqueItems
          final formatted12h = formatTo12Hour(resolvedValue);
          if (uniqueItems.contains(formatted12h)) {
            resolvedValue = formatted12h;
          } else {
            resolvedValue = formatted12h;
            uniqueItems.insert(0, resolvedValue);
          }
        }
      }
    }

    // Guard against edge cases where uniqueItems is still somehow empty
    if (uniqueItems.isEmpty) {
      uniqueItems.add(resolvedValue);
    }

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: resolvedValue,
          isExpanded: true,
          isDense: true,
          borderRadius: BorderRadius.circular(16),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Colors.black54, size: 20),
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          onChanged: onChanged,
          items: uniqueItems.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
