import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/constants/texts.dart';
import '../../../../core/common/widgets/logout_confirmation_dialog.dart';
import '../../../auth/presentation/controller/user_controller.dart';
import '../../../profile_static_screens/presentation/screens/about_app_screen.dart';
import '../../../profile_static_screens/presentation/screens/privacy_policy_screen.dart';
import '../../../profile_static_screens/presentation/screens/terms_conditions_screen.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import 'change_password_screen.dart';
import 'choose_language_screen.dart';
import 'edit_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<void> _refreshProfile() async {
    await Get.find<UserController>().fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          appTexts.profile.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProfile,
          child: Column(
            children: [
              // Profile Header with dynamic data
              Obx(() {
                final userController = Get.find<UserController>();
                return ProfileHeader(
                  userName: userController.userName,
                  userAvatar: userController.userProfileImage ?? 'assets/images/home_assets/profile.jpg',
                  onEditPressed: () {
                    Get.to(() => const EditProfileScreen());
                  },
                );
              }),
              const SizedBox(height: 8),
              // Menu Items
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // About App
                      ProfileMenuItem(
                        iconPath: 'assets/icons/chart-breakout-circle.png',
                        title: appTexts.aboutApp.tr,
                        onTap: () {
                          Get.to(() => const AboutAppScreen());
                        },
                      ),
                      // Privacy Policy
                      ProfileMenuItem(
                        iconPath: 'assets/icons/file-shield-02.png',
                        title: appTexts.privacyPolicy.tr,
                        onTap: () {
                          Get.to(() => const PrivacyPolicyScreen());
                        },
                      ),
                      // Term & Condition
                      ProfileMenuItem(
                        icon: Icons.receipt_outlined,
                        title: appTexts.generalTerms.tr,
                        onTap: () {
                          Get.to(() => const TermsConditionsScreen());
                        },
                      ),
                      // Change Password
                      ProfileMenuItem(
                        icon: Icons.lock_outline,
                        title: appTexts.changePassword.tr,
                        onTap: () {
                          Get.to(() => const ChangePasswordScreen());
                        },
                      ),
                      // Language
                      ProfileMenuItem(
                        icon: Icons.language_outlined,
                        title: appTexts.languages.tr,
                        onTap: () {
                          Get.to(() => const ChooseLanguageScreen());
                        },
                      ),
                      // Log Out
                      ProfileMenuItem(
                        iconPath: 'assets/icons/log-out-03.png',
                        title: appTexts.logout.tr,
                        isLogOut: true,
                        onTap: () {
                          showLogoutConfirmationDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
