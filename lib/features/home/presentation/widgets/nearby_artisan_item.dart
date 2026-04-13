import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../service/presentation/screens/service_details_screen.dart';

class NearbyArtisanItem extends StatelessWidget {
  final Map<String, dynamic> artisanData;
  final String? serviceId;
  final VoidCallback? onBookPressed;

  const NearbyArtisanItem({
    super.key,
    required this.artisanData,
    this.serviceId,
    this.onBookPressed,
  });

  /// Build service image - supports both asset and network images
  Widget _buildServiceImage() {
    final bgImage = artisanData['bgImage'];
    
    if (bgImage != null && bgImage.startsWith('http')) {
      // Network image from Cloudinary
      return Image.network(
        bgImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.updateGrey,
            child: const Icon(Icons.image, color: AppColors.subText, size: 40),
          );
        },
      );
    } else if (bgImage != null && bgImage.isNotEmpty) {
      // Asset image
      return Image.asset(
        bgImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.updateGrey,
            child: const Icon(Icons.image, color: AppColors.subText, size: 40),
          );
        },
      );
    } else {
      // No image provided
      return Container(
        color: AppColors.updateGrey,
        child: const Icon(Icons.image, color: AppColors.subText, size: 40),
      );
    }
  }

  /// Build provider avatar image - supports both asset and network images
  Widget _buildProviderImage() {
    final profileImage = artisanData['profileImage'];
    
    if (profileImage != null && profileImage.startsWith('http')) {
      // Network image from Cloudinary
      return Image.network(
        profileImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.updateGrey,
            child: const Icon(Icons.person, color: AppColors.subText, size: 14),
          );
        },
      );
    } else if (profileImage != null && profileImage.isNotEmpty) {
      // Asset image
      return Image.asset(
        profileImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.updateGrey,
            child: const Icon(Icons.person, color: AppColors.subText, size: 14),
          );
        },
      );
    } else {
      // No image provided
      return Container(
        color: AppColors.updateGrey,
        child: const Icon(Icons.person, color: AppColors.subText, size: 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: AppColors.homeNearbyArtisanBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Left image with category badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: SizedBox(
                  width: 120,
                  height: double.infinity,
                  child: _buildServiceImage(),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    artisanData['jobTitle'] ?? artisanData['category'] ?? 'Professional',
                    style: const TextStyle(
                      color: AppColors.homePrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Right Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: _buildProviderImage(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                artisanData['name'] ?? 'Professional',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                artisanData['username'] ?? artisanData['subtitle'] ?? '@Service Provider',
                                style: const TextStyle(
                                  color: AppColors.subText,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.starYellow, size: 16),
                          Text(
                            ' ${artisanData['rating'] ?? '4.8'}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.subText),
                          Text(
                            ' ${artisanData['distance'] ?? '2.5 km'}',
                            style: const TextStyle(fontSize: 12, color: AppColors.subText),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, size: 14, color: AppColors.subText),
                          Text(
                            artisanData['price'] ?? '45/hr',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: () {
                        if (serviceId != null) {
                          Get.to(() => ServiceDetailsScreen(serviceId: serviceId!));
                        } else {
                          onBookPressed?.call();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.homePrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          color: AppColors.primaryWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
