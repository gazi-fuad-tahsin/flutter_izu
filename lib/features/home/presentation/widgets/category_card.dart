import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String image;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.image,
    this.onTap,
  });

  Widget _buildCategoryImage() {
    // Check if it's a network URL or asset path
    if (image.startsWith('http')) {
      // Network image from Cloudinary
      return Image.network(
        image,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.homeCategoryPlaceholderBg,
            ),
            child: const Icon(
              Icons.image_not_supported,
              color: AppColors.primaryWhite,
              size: 40,
            ),
          );
        },
      );
    } else {
      // Asset image
      return Image.asset(
        image,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.homeCategoryPlaceholderBg,
            ),
            child: const Icon(
              Icons.image_not_supported,
              color: AppColors.primaryWhite,
              size: 40,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image container - fixed 80x80
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.homeCategoryPlaceholderBg,
              ),
              child: _buildCategoryImage(),
            ),
          ),
          const SizedBox(height: 8),
          // Category name - constrained width with proper ellipsis
          SizedBox(
            width: 80,
            height: 30,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

