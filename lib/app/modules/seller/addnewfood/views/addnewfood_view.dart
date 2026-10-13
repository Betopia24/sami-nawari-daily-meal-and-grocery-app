import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/custom_dropdown_field.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/addnewfood_controller.dart';
import '../widgets/image_picker_grid.dart';

class AddnewfoodView extends GetView<AddnewfoodController> {
  const AddnewfoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: CustomBackButton(),
        ),
        title: Text(
          'Add New Food',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
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
              'Basic Information',
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Food Name',
              hint: 'Enter food name',
              controller: controller.nameController,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Description',
              hint: 'Enter description',
              controller: controller.descriptionController,
              isRequired: true,
              maxLines: 4,
              maxLength: 200,
            ),
            const SizedBox(height: 16),
            Obx(() => ImagePickerGrid(
                  selectedImages: controller.selectedImages.toList(),
                  onImagesUpdated: controller.updateImages,
                )),
            const SizedBox(height: 16),
            Obx(() => CustomDropdownField<String>(
                  label: 'Category',
                  hintText: 'Choose category',
                  isRequired: true,
                  value: controller.selectedCategory.value,
                  items: controller.categories
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.selectedCategory.value = value;
                  },
                )),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Price',
              hint: '\$ 11.99',
              controller: controller.priceController,
              isRequired: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Continue',
              onPressed: () {
                Get.toNamed(Routes.addfooddetails);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
