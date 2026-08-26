import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../widgets/custom_text_field.dart';

class StepInputRow extends StatelessWidget {
  final int stepNumber;
  final String value;
  final void Function(String) onChanged;
  final VoidCallback? onDelete;

  const StepInputRow({
    super.key,
    required this.stepNumber,
    required this.value,
    required this.onChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value);
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CustomTextField(
        label: 'Step $stepNumber',
        hint: 'Enter step details',
        controller: controller,
        maxLines: 4,
        maxLength: 200,
        onChanged: onChanged,
        labelTrailing: onDelete != null
            ? InkWell(
                onTap: onDelete,
                child: SvgPicture.asset(
                  AppAssets.deleteIcon,
                  height: 24,
                  width: 24,
                ),
              )
            : null,
      ),
    );
  }
}
