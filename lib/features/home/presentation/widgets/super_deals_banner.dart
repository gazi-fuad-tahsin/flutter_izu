import 'package:flutter/material.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/theme/app_colors.dart';

class SuperDealsBanner extends StatelessWidget {
  final VoidCallback? onPressed;

  const SuperDealsBanner({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.homeBannerGradientStart, AppColors.homeBannerGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  IzuHomeTexts.superDeals,
                  style: TextStyle(
                    color: AppColors.primaryWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  IzuHomeTexts.superDealsSubtitle,
                  style: TextStyle(
                    color: AppColors.primaryWhite,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.homePrimary,
                    foregroundColor: AppColors.primaryWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    minimumSize: const Size(110, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text(
                    IzuHomeTexts.allServices,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 15,
            bottom: 0,
            child: SizedBox(
              width: 170,
              height: 180,
              child: Image.asset(
                'assets/images/builder_man_image.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
