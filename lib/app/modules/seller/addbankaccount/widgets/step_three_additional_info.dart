import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/custom_text_field.dart';

class StepThreeAdditionalInfo extends StatelessWidget {
  const StepThreeAdditionalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information (Optional)',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'ROUTING NUMBER',
          hint: 'Enter Routing Number',
          controller: TextEditingController(),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'SWIFT/BIC CODE',
          subLabel: 'Required for international transfers',
          hint: 'Enter SWIFT/BIC Code',
          controller: TextEditingController(),
        ),
      ],
    );
  }
}
