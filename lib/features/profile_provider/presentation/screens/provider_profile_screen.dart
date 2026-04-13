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
import 'provider_edit_profile_screen.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.screenBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with edit button
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

              // Profile Picture Section
              Column(
                children: [
                  // Profile Image
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ProviderColors.profileAvatarBG,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profile_avatar.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Star Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      int.parse(ProviderProfileTexts.ratingValue),
                      (index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.star,
                          color: ProviderColors.secondaryOrange,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    ProviderProfileTexts.providerName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: ProviderColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Email
                  Text(
                    ProviderProfileTexts.providerEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ProviderColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Phone
                  Text(
                    ProviderProfileTexts.providerPhone,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ProviderColors.textGrey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Stats Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    // Work Completion
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

                    // Your Earning
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

              // Menu Items
              _buildMenuItem(
                icon: Icons.work_outline,
                title: ProviderProfileTexts.yourServices,
                onTap: () {
                  Get.to(() => const YourServicesScreen());
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

              // Log Out Button
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
}
