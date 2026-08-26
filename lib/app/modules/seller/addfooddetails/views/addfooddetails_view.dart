import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/custom_dropdown_field.dart';
import '../../../../widgets/dashed_border_button.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/addfooddetails_controller.dart';
import '../widgets/ingredient_input_row.dart';
import '../widgets/step_input_row.dart';
import '../widgets/delivery_option_card.dart';
import '../../../../routes/app_routes.dart';

class AddfooddetailsView extends GetView<AddfooddetailsController> {
  const AddfooddetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 24.0, top: 8, bottom: 8),
          child: CustomBackButton(),
        ),
        title: Text(
          'Food Details',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preparation & Information',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Preparation Time',
              hint: '45 minutes',
              controller: TextEditingController(text: controller.preparationTime.value),
              isRequired: true,
              onChanged: (val) => controller.preparationTime.value = val,
            ),
            const SizedBox(height: 24),
            
            // Ingredients List
            Obx(() => Column(
              children: List.generate(controller.ingredients.length, (index) {
                final ingredient = controller.ingredients[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: IngredientInputRow(
                    nameLabel: 'Ingredient Name',
                    nameHint: 'Paneer, Butter, Tomato...',
                    isRequired: index == 0,
                    nameValue: ingredient.name,
                    quantityValue: ingredient.quantity,
                    unitValue: ingredient.unit,
                    onNameChanged: (val) => controller.updateIngredientName(index, val),
                    onQuantityChanged: (val) => controller.updateIngredientQuantity(index, val),
                    onUnitChanged: (val) => controller.updateIngredientUnit(index, val ?? 'Piece (pcs)'),
                    onDelete: controller.ingredients.length > 1
                        ? () => controller.removeIngredient(index)
                        : null,
                  ),
                );
              }),
            )),
            
            DashedBorderButton(
              text: '+ Add More',
              onTap: controller.addIngredient,
              color: AppColors.primary,
              textColor: AppColors.primary,
              iconColor: AppColors.primary,
            ),
            
            const SizedBox(height: 32),
            RichText(
              text: TextSpan(
                text: 'Cooking Method ',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                children: [
                  TextSpan(
                    text: '(step by step)',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextSpan(
                    text: '*',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Steps List
            Obx(() => Column(
              children: List.generate(controller.cookingSteps.length, (index) {
                return StepInputRow(
                  stepNumber: index + 1,
                  value: controller.cookingSteps[index],
                  onChanged: (val) => controller.updateStep(index, val),
                  onDelete: controller.cookingSteps.length > 1
                      ? () => controller.removeStep(index)
                      : null,
                );
              }),
            )),
            
            DashedBorderButton(
              text: '+ Add More Step',
              onTap: controller.addStep,
              color: AppColors.primary,
              textColor: AppColors.primary,
              iconColor: AppColors.primary,
            ),
            
            const SizedBox(height: 32),
            
            Obx(() => DeliveryOptionCard(
              title: 'Pickup',
              subtitle: 'Customers will pickup from your location',
              trailingText: 'Free',
              iconPath: AppAssets.pickupIcon,
              isSelected: controller.isPickup.value,
              onTap: controller.togglePickup,
            )),
            
            Obx(() => DeliveryOptionCard(
              title: 'Delivery',
              subtitle: 'You will deliver the orders',
              trailingText: controller.deliveryFee.value,
              iconPath: AppAssets.deliveryIcon,
              isSelected: controller.isDelivery.value,
              onTap: controller.toggleDelivery,
            )),
            
            const SizedBox(height: 16),
            
            Obx(() => CustomDropdownField<String>(
              label: 'Delivery Fee',
              isRequired: true,
              value: controller.deliveryFee.value,
              items: controller.deliveryFees
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  controller.deliveryFee.value = val;
                }
              },
            )),
            
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Continue',
              onPressed: () {
                Get.toNamed(Routes.previewfood);
              },
            ),
          ],
        ),
      ),
    );
  }
}
