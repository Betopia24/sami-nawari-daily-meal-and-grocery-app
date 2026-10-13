import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/custom_dropdown_field.dart';
import '../../../../../core/utils/app_assets.dart';

class StepOneBankInfo extends StatelessWidget {
  const StepOneBankInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank Information',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'BANK NAME',
          hint: 'Search Bank Name',
          prefixIcon: AppAssets.searchIcon,
          controller: TextEditingController(),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'BRANCH NAME (OPTIONAL)',
          hint: 'Enter Branch Name',
          controller: TextEditingController(),
        ),
        const SizedBox(height: 20),
        CustomDropdownField<String>(
          label: 'COUNTRY NAME',
          hintText: 'Select Country',
          value: 'Bangladesh',
          items: const [
            DropdownMenuItem(
              value: 'Bangladesh',
              child: Text('Bangladesh'),
            ),
          ],
          onChanged: (val) {},
        ),
      ],
    );
  }
}
