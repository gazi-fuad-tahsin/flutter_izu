import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/common/widgets/logout_confirmation_dialog.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/screens/change_password_screen.dart';
import '../../../profile/presentation/screens/choose_language_screen.dart';
import '../../../profile_static_screens/presentation/screens/privacy_policy_screen.dart';
import '../../../profile_static_screens/presentation/screens/terms_conditions_screen.dart';
import '../../../provider_jobs/presentation/screens/your_services_screen.dart';
import '../../presentation/controller/provider_profile_controller.dart';
import 'provider_edit_profile_screen.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  late ProviderProfileController _controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ProviderProfileController>()) {
      _controller = Get.find<ProviderProfileController>();
      _controller.fetchProfileData();
    } else {
      _controller = Get.put(ProviderProfileController());
    }
  }

  Future<void> _refreshProfile() async {
    await _controller.fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.screenBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      Text(
                        ProviderProfileTexts.profileTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ProviderColors.textBlack,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ProviderEditProfileScreen());
                        },
                        child: Image.asset(
                          'assets/icons/edit-05.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Obx(() {
                  if (_controller.isLoading.value) {
                    return const SizedBox(
                      height: 280,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF2870BC),
                          ),
                        ),
                      ),
                    );
                  }

                  final profile = _controller.profileData.value;
                  return Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ProviderColors.profileAvatarBG,
                        ),
                        child: _buildProfileImage(profile?.profileImage ?? ''),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) {
                            int rating = 0;
                            try {
                              if (profile?.overallAverageRating != null) {
                                rating = (double.tryParse(
                                      profile!.overallAverageRating.toString(),
                                    ) ??
                                    0.0)
                                    .toInt();
                              }
                            } catch (e) {
                              rating = 0;
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                index < rating ? Icons.star : Icons.star_border,
                                color: ProviderColors.secondaryOrange,
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile?.name ?? 'Provider',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: ProviderColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile?.email ?? 'email@example.com',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ProviderColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile?.phone ?? 'No phone',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ProviderColors.textGrey,
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: ProviderColors.workCompletionOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ProviderProfileTexts.workCompletion,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ProviderProfileTexts.workCompletionValue,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: ProviderColors.earningBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ProviderProfileTexts.yourEarning,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ProviderProfileTexts.earningValue,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _buildMenuItem(
                  icon: Icons.work_outline,
                  title: ProviderProfileTexts.yourServices,
                  onTap: () {
                    Get.to(() => const YourServicesScreen(showBackButton: true));
                  },
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: ProviderProfileTexts.changePassword,
                  onTap: () {
                    Get.to(() => const ChangePasswordScreen());
                  },
                ),
                _buildMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: ProviderProfileTexts.privacyPolicy,
                  onTap: () {
                    Get.to(() => const PrivacyPolicyScreen());
                  },
                ),
                _buildMenuItem(
                  icon: Icons.description_outlined,
                  title: ProviderProfileTexts.termAndCondition,
                  onTap: () {
                    Get.to(() => const TermsConditionsScreen());
                  },
                ),
                _buildMenuItem(
                  icon: Icons.language,
                  title: ProviderProfileTexts.language,
                  onTap: () {
                    Get.to(() => const ChooseLanguageScreen());
                  },
                ),

                const SizedBox(height: 8),

                _buildMenuItemRed(
                  icon: Icons.logout_outlined,
                  title: ProviderProfileTexts.logOut,
                  onTap: () {
                    showLogoutConfirmationDialog(context);
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: ProviderColors.textBlack,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ProviderColors.textBlack,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: ProviderColors.textGrey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            height: 1,
            color: ProviderColors.dividerGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItemRed({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: ProviderColors.textRed,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ProviderColors.textRed,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: ProviderColors.textRed,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            height: 1,
            color: ProviderColors.dividerGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade300,
              child: Icon(
                Icons.person,
                color: Colors.grey.shade600,
                size: 60,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey.shade200,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      );
    }

    return ClipOval(
      child: Image.asset(
        imageUrl.isEmpty ? 'assets/images/profile_image.png' : imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade300,
            child: Icon(
              Icons.person,
              color: Colors.grey.shade600,
              size: 60,
            ),
          );
        },
      ),
    );
  }
}
