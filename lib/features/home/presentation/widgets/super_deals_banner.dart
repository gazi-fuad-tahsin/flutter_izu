import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/theme/app_colors.dart';

class SuperDealsBanner extends StatefulWidget {
  final VoidCallback? onPressed;

  const SuperDealsBanner({super.key, this.onPressed});

  @override
  State<SuperDealsBanner> createState() => _SuperDealsBannerState();
}

class _SuperDealsBannerState extends State<SuperDealsBanner> {
  static const int _bannerCount = 4;
  static const Duration _autoPlayDuration = Duration(seconds: 3);

  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isMovingForward = true;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _autoPlayTimer = Timer.periodic(_autoPlayDuration, (_) {
      if (!mounted || !_pageController.hasClients) return;
      if (_currentPage == 0) {
        _isMovingForward = true;
      } else if (_currentPage == _bannerCount - 1) {
        _isMovingForward = false;
      }

      final nextPage = _isMovingForward ? _currentPage + 1 : _currentPage - 1;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildBannerCard() {
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
                Text(
                  IzuHomeTexts.superDeals,
                  style: const TextStyle(
                    color: AppColors.primaryWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  IzuHomeTexts.superDealsSubtitle,
                  style: const TextStyle(
                    color: AppColors.primaryWhite,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: widget.onPressed,
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
                  child: Text(
                    IzuHomeTexts.allServices,
                    style: const TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _bannerCount,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                if (_currentPage == 0) {
                  _isMovingForward = true;
                } else if (_currentPage == _bannerCount - 1) {
                  _isMovingForward = false;
                }
              });
            },
            itemBuilder: (context, index) => _buildBannerCard(),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerCount, (index) {
            final isActive = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 9 : 7,
              height: isActive ? 9 : 7,
              decoration: BoxDecoration(
                color: isActive ? AppColors.homePrimary : AppColors.homeBannerGradientEnd.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}
