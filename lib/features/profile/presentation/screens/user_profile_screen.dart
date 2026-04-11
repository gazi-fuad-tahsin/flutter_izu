import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../profile_static_screens/presentation/screens/about_app_screen.dart';
import '../../../profile_static_screens/presentation/screens/privacy_policy_screen.dart';
import '../../../profile_static_screens/presentation/screens/terms_conditions_screen.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import 'change_password_screen.dart';
import 'choose_language_screen.dart';
import 'edit_profile_screen.dart';
import 'logout_confirmation_screen.dart';
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final String userName = 'Madiha Arora';
  final String userAvatar = 'assets/images/home_assets/profile.jpg';

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
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            ProfileHeader(
              userName: userName,
              userAvatar: userAvatar,
              onEditPressed: () {
                Get.to(() => const EditProfileScreen());
              },
            ),
            const SizedBox(height: 8),
            // Menu Items
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // About App
                    ProfileMenuItem(
                      iconPath: 'assets/icons/chart-breakout-circle.png',
                      title: 'About App',
                      onTap: () {
                        Get.to(() => const AboutAppScreen());
                      },
                    ),
                    // Privacy Policy
                    ProfileMenuItem(
                      iconPath: 'assets/icons/file-shield-02.png',
                      title: 'Privacy Policy',
                      onTap: () {
                        Get.to(() => const PrivacyPolicyScreen());
                      },
                    ),
                    // Term & Condition
                    ProfileMenuItem(
                      icon: Icons.receipt_outlined,
                      title: 'Term & Condition',
                      onTap: () {
                        Get.to(() => const TermsConditionsScreen());
                      },
                    ),
                    // Change Password
                    ProfileMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {
                        Get.to(() => const ChangePasswordScreen());
                      },
                    ),
                    // Language
                    ProfileMenuItem(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      onTap: () {
                        Get.to(() => const ChooseLanguageScreen());
                      },
                    ),
                    // Log Out
                    ProfileMenuItem(
                      iconPath: 'assets/icons/log-out-03.png',
                      title: 'Log Out',
                      isLogOut: true,
                      onTap: () {
                        Get.to(() => const LogoutConfirmationScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
