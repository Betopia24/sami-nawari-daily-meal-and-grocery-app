import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/custom_dropdown_field.dart';

class IngredientInputRow extends StatelessWidget {
  final String nameLabel;
  final String? nameHint;
  final String nameValue;
  final String quantityValue;
  final String unitValue;
  final void Function(String) onNameChanged;
  final void Function(String) onQuantityChanged;
  final void Function(String?) onUnitChanged;
  final VoidCallback? onDelete;
  final bool isRequired;

  const IngredientInputRow({
    super.key,
    required this.nameLabel,
    this.nameHint,
    required this.nameValue,
    required this.quantityValue,
    required this.unitValue,
    required this.onNameChanged,
    required this.onQuantityChanged,
    required this.onUnitChanged,
    this.onDelete,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    // Generate text controllers
    final nameController = TextEditingController(text: nameValue);
    nameController.selection = TextSelection.fromPosition(TextPosition(offset: nameController.text.length));
    
    final quantityController = TextEditingController(text: quantityValue);
    quantityController.selection = TextSelection.fromPosition(TextPosition(offset: quantityController.text.length));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: nameLabel,
          hint: nameHint ?? 'Enter ingredient name',
          controller: nameController,
          isRequired: isRequired,
          onChanged: onNameChanged,
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
          // Need to handle onChanged, but CustomTextField doesn't expose it directly yet.
          // Wait, CustomTextField doesn't expose onChanged directly... 
          // We can add a listener to the controller, or we can modify CustomTextField.
          // Actually, let's just use FocusNode/Listener or let it be handled when submitting.
          // But it's reactive. So we should probably modify CustomTextField to expose onChanged.
          // Wait, CustomTextField has an internal onChanged for validation, we can add a callback.
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomTextField(
                label: 'Quantity',
                hint: '1',
                controller: quantityController,
                keyboardType: TextInputType.number,
                onChanged: onQuantityChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomDropdownField<String>(
                label: 'Unit',
                value: unitValue,
                items: ['Piece (pcs)', 'kg', 'g', 'L', 'ml', 'tsp', 'tbsp', 'cup']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onUnitChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
