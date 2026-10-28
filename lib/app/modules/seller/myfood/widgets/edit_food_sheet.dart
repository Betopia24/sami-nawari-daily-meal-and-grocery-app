import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../data/models/seller_food_model.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/myfood_controller.dart';

class _EditIngredientItem {
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController unitController;

  _EditIngredientItem({
    required String name,
    required num quantity,
    required String unit,
  })  : nameController = TextEditingController(text: name),
        quantityController = TextEditingController(
          text: quantity % 1 == 0
              ? quantity.toInt().toString()
              : quantity.toString(),
        ),
        unitController = TextEditingController(text: unit);

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    unitController.dispose();
  }
}

class EditFoodSheet extends StatefulWidget {
  final SellerFoodItem food;
  final MyFoodController controller;

  const EditFoodSheet({
    super.key,
    required this.food,
    required this.controller,
  });

  @override
  State<EditFoodSheet> createState() => _EditFoodSheetState();
}

class _EditFoodSheetState extends State<EditFoodSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _prepTimeController;
  late final TextEditingController _deliveryFeeController;

  late final List<_EditIngredientItem> _ingredients;
  late String _selectedCategory;
  late bool _pickupAvailable;
  late bool _deliveryAvailable;
  bool _isSaving = false;

  final List<String> _categoryOptions = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.food.name);
    _descriptionController =
        TextEditingController(text: widget.food.description);
    _priceController = TextEditingController(
      text: widget.food.price > 0 ? widget.food.price.toString() : '',
    );
    _prepTimeController =
        TextEditingController(text: widget.food.preparationTime);
    _deliveryFeeController = TextEditingController(
      text: widget.food.deliveryFee > 0
          ? widget.food.deliveryFee.toString()
          : '0',
    );

    _ingredients = widget.food.ingredients
        .map((i) => _EditIngredientItem(
              name: i.name,
              quantity: i.quantity,
              unit: i.unit,
            ))
        .toList();

    // Normalize category
    final matchedCat = _categoryOptions.firstWhere(
      (c) => c.toUpperCase() == widget.food.category.toUpperCase(),
      orElse: () => 'Breakfast',
    );
    _selectedCategory = matchedCat;

    _pickupAvailable = widget.food.pickupAvailable;
    _deliveryAvailable = widget.food.deliveryAvailable;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _prepTimeController.dispose();
    _deliveryFeeController.dispose();
    for (final item in _ingredients) {
      item.dispose();
    }
    super.dispose();
  }

  String _getSubcategoryForCategory(String category) {
    switch (category.toUpperCase()) {
      case 'BREAKFAST':
        return 'QUICK';
      case 'LUNCH':
        return 'LIGHT';
      case 'DINNER':
        return 'FAMILY';
      case 'SNACKS':
        return 'SAVORY';
      default:
        return 'QUICK';
    }
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add(_EditIngredientItem(
        name: '',
        quantity: 1,
        unit: 'Piece (pcs)',
      ));
    });
  }

  void _removeIngredient(int index) {
    if (index >= 0 && index < _ingredients.length) {
      setState(() {
        final removed = _ingredients.removeAt(index);
        removed.dispose();
      });
    }
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final prepTime = _prepTimeController.text.trim();
    final deliveryFee =
        double.tryParse(_deliveryFeeController.text.trim()) ?? 0.0;

    if (name.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter food name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    if (price == null || price <= 0) {
      Get.snackbar(
        'Invalid Price',
        'Please enter a valid price (e.g. 15.00)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isSaving = true);

    // Build ingredients array with NUMERIC quantity
    final validIngredients = _ingredients
        .where((i) => i.nameController.text.trim().isNotEmpty)
        .map((i) {
          final q = num.tryParse(i.quantityController.text.trim()) ?? 1;
          return <String, dynamic>{
            'name': i.nameController.text.trim(),
            'quantity': q, // STRICTLY A NUMBER (num), NOT A STRING
            'unit': i.unitController.text.trim().isNotEmpty
                ? i.unitController.text.trim()
                : 'Piece (pcs)',
          };
        })
        .toList();

    final payload = <String, dynamic>{
      'name': name,
      'description': description,
      'category': _selectedCategory.toUpperCase(),
      'subcategory': widget.food.subcategory.isNotEmpty
          ? widget.food.subcategory
          : _getSubcategoryForCategory(_selectedCategory),
      'price': price,
      'preparationTime':
          prepTime.isNotEmpty ? prepTime : widget.food.preparationTime,
      'deliveryFee': deliveryFee,
      'pickupAvailable': _pickupAvailable,
      'deliveryAvailable': _deliveryAvailable,
    };

    if (validIngredients.isNotEmpty) {
      payload['ingredients'] = validIngredients;
    }

    final success = await widget.controller.updateFood(widget.food.id, payload);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sheet Header
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Food Listing',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const Divider(color: AppColors.borderGrey),
              const SizedBox(height: 12),

              // Food Name
              CustomTextField(
                label: 'Food Name',
                hint: 'e.g. Mango Salad',
                controller: _nameController,
                isRequired: true,
              ),
              const SizedBox(height: 16),

              // Category Selector
              Text(
                'Category',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categoryOptions.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.backgroundOffWhite,
                    labelStyle: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color:
                            isSelected ? AppColors.primary : AppColors.borderGrey,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Price & Preparation Time
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Price (\$)',
                      hint: 'e.g. 12.00',
                      controller: _priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Prep Time',
                      hint: 'e.g. 25 mins',
                      controller: _prepTimeController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Delivery Fee
              CustomTextField(
                label: 'Delivery Fee (\$)',
                hint: 'e.g. 2.50',
                controller: _deliveryFeeController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),

              // Description
              CustomTextField(
                label: 'Description',
                hint: 'Enter detailed description of the food item',
                controller: _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Ingredients Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ingredients',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addIngredient,
                    icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                    label: Text(
                      'Add Ingredient',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              if (_ingredients.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundOffWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  child: Center(
                    child: Text(
                      'No ingredients added. Tap "+ Add Ingredient" to add.',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
              else
                ..._ingredients.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: item.nameController,
                            style: GoogleFonts.outfit(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Item name',
                              hintStyle: GoogleFonts.outfit(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              filled: true,
                              fillColor: AppColors.backgroundOffWhite,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.borderGrey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.borderGrey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: item.quantityController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: GoogleFonts.outfit(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Qty (e.g. 2)',
                              hintStyle: GoogleFonts.outfit(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              filled: true,
                              fillColor: AppColors.backgroundOffWhite,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.borderGrey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.borderGrey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: item.unitController,
                            style: GoogleFonts.outfit(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Unit (kg/pcs)',
                              hintStyle: GoogleFonts.outfit(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              filled: true,
                              fillColor: AppColors.backgroundOffWhite,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.borderGrey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.borderGrey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _removeIngredient(index),
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.all(8),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 16),

              // Pickup & Delivery Switches (Wrapped in Material to satisfy ink splash requirement)
              Material(
                color: AppColors.backgroundOffWhite,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppColors.borderGrey),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Pickup Available',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        value: _pickupAvailable,
                        activeTrackColor: AppColors.primary,
                        onChanged: (val) =>
                            setState(() => _pickupAvailable = val),
                      ),
                      const Divider(color: AppColors.borderGrey, height: 1),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Delivery Available',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        value: _deliveryAvailable,
                        activeTrackColor: AppColors.primary,
                        onChanged: (val) =>
                            setState(() => _deliveryAvailable = val),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Changes Button
              PrimaryButton(
                text: _isSaving ? 'Saving Changes...' : 'Save Changes',
                isEnabled: !_isSaving,
                showArrow: false,
                onPressed: _handleSave,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
