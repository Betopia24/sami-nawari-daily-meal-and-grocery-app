import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/custom_dropdown_field.dart';

class StepTwoAccountInfo extends StatelessWidget {
  const StepTwoAccountInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Information',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'ACCOUNT HOLDER NAME',
          hint: 'Enter Account Holder Name',
          controller: TextEditingController(),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'ACCOUNT NUMBER',
          hint: 'Enter Account Number',
          controller: TextEditingController(),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        CustomDropdownField<String>(
          label: 'ACCOUNT TYPE',
          hintText: 'Select Account Type',
          value: null,
          items: const [
            DropdownMenuItem(
              value: 'Savings',
              child: Text('Savings'),
            ),
            DropdownMenuItem(
              value: 'Checking',
              child: Text('Checking'),
            ),
          ],
          onChanged: (val) {},
        ),
        const SizedBox(height: 20),
        CustomDropdownField<String>(
          label: 'CURRENCY TYPE',
          hintText: 'Select Currency',
          value: null,
          items: const [
            DropdownMenuItem(
              value: 'USD',
              child: Text('USD'),
            ),
            DropdownMenuItem(
              value: 'BDT',
              child: Text('BDT'),
            ),
          ],
          onChanged: (val) {},
        ),
      ],
    );
  }
}
