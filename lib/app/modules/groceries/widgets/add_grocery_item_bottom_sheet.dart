import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../widgets/primary_button.dart';
import '../../../../core/utils/app_assets.dart';
import '../controllers/groceries_controller.dart';

class AddGroceryItemBottomSheet extends StatefulWidget {
  final String? initialItemName;
  final IconData? initialItemIcon;
  final GroceryItemModel? itemToEdit;
  const AddGroceryItemBottomSheet({super.key, this.initialItemName, this.initialItemIcon, this.itemToEdit});

  @override
  State<AddGroceryItemBottomSheet> createState() => _AddGroceryItemBottomSheetState();
}

class _AddGroceryItemBottomSheetState extends State<AddGroceryItemBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1');
  
  String _selectedUnit = 'Piece (pcs)';
  String _selectedCategory = 'Other';
  String _selectedPriority = 'No priority';

  final List<String> _units = [
    'Kilogram (kg)', 'Gram (g)', 'Liter (L)', 'Mililiter (ml)',
    'Piece (pcs)', 'Packet', 'Bottle', 'Box', 'Can', 'Dozen',
    'Bundle', 'Bag', 'Other (unit)'
  ];
  final List<String> _categories = [
    'Meat', 'Fish', 'Chiken', 'Bakery', 'Pantry', 'Bevarages',
    'Frozen Food', 'Cleaning', 'Baby Care', 'Personal Care', 'Other'
  ];
  final List<String> _priorities = ['No priority', 'High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    if (widget.itemToEdit != null) {
      _nameController.text = widget.itemToEdit!.title;
      // parse quantity and unit
      if (widget.itemToEdit!.sizeInfo.isNotEmpty) {
        final parts = widget.itemToEdit!.sizeInfo.split(' ');
        if (parts.isNotEmpty) {
          _quantityController.text = parts[0];
          if (parts.length > 1) {
            final unitStr = parts.sublist(1).join(' ');
            if (_units.any((u) => u.contains(unitStr) || unitStr.contains(u.split(' ')[0]))) {
              _selectedUnit = _units.firstWhere((u) => u.contains(unitStr) || unitStr.contains(u.split(' ')[0]), orElse: () => _units.first);
            }
          }
        }
      }
      if (widget.itemToEdit!.tagInfo.isNotEmpty) {
        if (_priorities.contains(widget.itemToEdit!.tagInfo)) {
          _selectedPriority = widget.itemToEdit!.tagInfo;
        } else if (_categories.contains(widget.itemToEdit!.tagInfo)) {
          _selectedCategory = widget.itemToEdit!.tagInfo;
        }
      }
    } else if (widget.initialItemName != null) {
      _nameController.text = widget.initialItemName!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the active list name if available
    final GroceriesController controller = Get.find();
    final activeListName = controller.groceryLists.isNotEmpty 
        ? controller.groceryLists[0].name 
        : "Grocery List";

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC), // Off-white cream color from mockup
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Close Button
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close, color: AppColors.textPrimary, size: 20.sp),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      widget.initialItemName != null ? 'Item Details' : 'Add Grocery Item',
                      style: GoogleFonts.outfit(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Adding to $activeListName',
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),

            if (widget.initialItemName == null) ...[
              // Item Name Input
              _buildLabel('Item Name'),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: _nameController,
                hint: 'Rice, Milk, Chiken,Oil...',
                isFocused: true,
              ),
              SizedBox(height: 16.h),
            ],

            // Quantity and Unit Row
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Quantity'),
                      SizedBox(height: 8.h),
                      _buildQuantityField(),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Unit'),
                      SizedBox(height: 8.h),
                      _buildDropdownField(
                        value: _selectedUnit,
                        items: _units,
                        onChanged: (val) => setState(() => _selectedUnit = val!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Category and Priority Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Category'),
                      SizedBox(height: 8.h),
                      _buildDropdownField(
                        value: _selectedCategory,
                        items: _categories,
                        onChanged: (val) => setState(() => _selectedCategory = val!),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Priority'),
                      SizedBox(height: 8.h),
                      _buildDropdownField(
                        value: _selectedPriority,
                        items: _priorities,
                        onChanged: (val) => setState(() => _selectedPriority = val!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Notes Input
            _buildLabel('Notes (Optional)'),
            SizedBox(height: 8.h),
            _buildTextField(
              controller: _notesController,
              hint: 'Fresh only, low fat, organic...',
              maxLines: 3,
            ),
            SizedBox(height: 32.h),

            // Add Item Button
            PrimaryButton(
              text: widget.itemToEdit != null ? 'Save Item' : 'Add Item',
              showArrow: false,
              prefixIcon: widget.itemToEdit != null ? Icons.save : Icons.add,
              onPressed: () {
                final newItem = GroceryItemModel(
                  title: _nameController.text.isNotEmpty ? _nameController.text : 'New Item',
                  iconAsset: widget.itemToEdit?.iconAsset ?? AppAssets.veganEmojiIcon, 
                  fallbackIcon: widget.initialItemIcon ?? widget.itemToEdit?.fallbackIcon ?? Icons.shopping_bag_outlined,
                  sizeInfo: '${_quantityController.text.isNotEmpty ? _quantityController.text : '1'} ${_selectedUnit.split(' ')[0]}',
                  tagInfo: _selectedPriority != 'No priority' ? _selectedPriority : (_selectedCategory != 'Other' ? _selectedCategory : 'Normal'),
                  addedBy: widget.itemToEdit?.addedBy ?? 'Me',
                  isCompleted: widget.itemToEdit?.isCompleted ?? false,
                  completedAgo: widget.itemToEdit?.completedAgo,
                );
                
                final controller = Get.find<GroceriesController>();
                if (widget.itemToEdit != null) {
                  controller.updateItem(widget.itemToEdit!, newItem);
                } else {
                  controller.pendingItems.insert(0, newItem);
                }
                
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isFocused = false,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isFocused ? Colors.transparent : const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isFocused ? AppColors.primary : Colors.transparent,
          width: 1.w,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFAAAAAA),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
        style: GoogleFonts.outfit(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildQuantityField() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  int current = int.tryParse(_quantityController.text) ?? 0;
                  _quantityController.text = (current + 1).toString();
                },
                child: Icon(Icons.arrow_drop_up, size: 20.sp, color: AppColors.textDark),
              ),
              GestureDetector(
                onTap: () {
                  int current = int.tryParse(_quantityController.text) ?? 0;
                  if (current > 1) {
                    _quantityController.text = (current - 1).toString();
                  }
                },
                child: Icon(Icons.arrow_drop_down, size: 20.sp, color: AppColors.textDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12.r),
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textDark, size: 20.sp),
          items: items.map((String item) {
            final isSelected = item == value;
            return DropdownMenuItem<String>(
              value: item,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEFF5F0) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w600,
                        color: const Color(0xFF7D7A75),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check, size: 16.sp, color: const Color(0xFF7D7A75)),
                  ],
                ),
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDark,
                  ),
                ),
              );
            }).toList();
          },
          onChanged: onChanged,
        ),
      ),
    );
  }
}
