import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/constants/app_dimensions.dart';
import 'package:hostel_finder/presentation/controllers/owner_controller.dart';

class MultiPhotoPicker extends StatelessWidget {
  const MultiPhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerController>();

    return Obx(() {
      final totalCount = controller.existingImageUrls.length +
          controller.selectedImages.length;
      final canAddMore = totalCount < OwnerController.maxPhotos;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Counter
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "$totalCount of ${OwnerController.maxPhotos} photos",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Thumbnails grid
          if (totalCount == 0)
            _AddPhotoButton(onTap: () => controller.pickImages())
          else
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Existing images 
                  ...List.generate(
                    controller.existingImageUrls.length,
                    (i) => _PhotoThumbnail(
                      imageUrl: controller.existingImageUrls[i],
                      onRemove: () => controller.removeExistingImage(i),
                    ),
                  ),

                  // New images (not yet uploaded)
                  ...List.generate(
                    controller.selectedImages.length,
                    (i) => _PhotoThumbnail(
                      filePath: controller.selectedImages[i].path,
                      onRemove: () => controller.removeNewImage(i),
                    ),
                  ),

                  // Add more button
                  if (canAddMore)
                    _AddMoreButton(onTap: () => controller.pickImages()),
                ],
              ),
            ),
        ],
      );
    });
  }
}

///  Single photo thumbnail with remove button
class _PhotoThumbnail extends StatelessWidget {
  final String? imageUrl;
  final String? filePath;
  final VoidCallback onRemove;

  const _PhotoThumbnail({
    this.imageUrl,
    this.filePath,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        Container(color: Colors.grey[200]),
                  )
                : Image.file(
                    File(filePath!),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///  Big "Add Photo" button (shown when no photos yet)
class _AddPhotoButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddPhotoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              "Tap to add photos",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

///  Small "Add More" tile (shown alongside existing thumbnails)
class _AddMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddMoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(
            color: Colors.grey[400]!,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: const Center(
          child: Icon(Icons.add_photo_alternate, color: Colors.grey, size: 30),
        ),
      ),
    );
  }
}