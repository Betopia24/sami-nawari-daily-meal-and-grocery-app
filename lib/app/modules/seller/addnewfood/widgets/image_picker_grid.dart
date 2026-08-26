import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../widgets/dashed_border_button.dart';

class ImagePickerGrid extends StatefulWidget {
  final List<File> selectedImages;
  final void Function(List<File>) onImagesUpdated;
  
  const ImagePickerGrid({
    super.key,
    required this.selectedImages,
    required this.onImagesUpdated,
  });

  @override
  State<ImagePickerGrid> createState() => _ImagePickerGridState();
}

class _ImagePickerGridState extends State<ImagePickerGrid> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final updatedList = List<File>.from(widget.selectedImages)..add(File(pickedFile.path));
      widget.onImagesUpdated(updatedList);
    }
  }

  void _removeImage(int index) {
    final updatedList = List<File>.from(widget.selectedImages)..removeAt(index);
    widget.onImagesUpdated(updatedList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Food Images',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: '*',
                style: GoogleFonts.outfit(
                  color: AppColors.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...widget.selectedImages.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: FileImage(file),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
            
            // Add Button
            GestureDetector(
              onTap: _pickImage,
              child: CustomPaint(
                painter: DashedRectPainter(
                  color: Colors.grey.shade400,
                  strokeWidth: 1.5,
                  gap: 6.0,
                  radius: 16.0,
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 32,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
