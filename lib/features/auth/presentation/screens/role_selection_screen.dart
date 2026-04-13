import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/network/services/auth_storage_service.dart';
import '../../../../../core/theme/app_colors.dart';
import 'create_account_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _selectedRole = 'user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // App Logo
              Image.asset(
                'assets/images/izu_logo.png',
                width: 140,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              // Heading
              Text(
                IzuAuthTexts.selectRoleTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                IzuAuthTexts.selectRoleSubtitle,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

              // User Card
              GestureDetector(
                onTap: () => setState(() => _selectedRole = 'user'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _selectedRole == 'user'
                        ? AppColors.homePrimary
                        : AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.homePrimary, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AppColors.authTextOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: AppColors.primaryWhite, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              IzuAuthTexts.continueAsUser,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _selectedRole == 'user'
                                    ? AppColors.primaryWhite
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              IzuAuthTexts.bookForService,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: _selectedRole == 'user'
                                    ? AppColors.primaryWhite.withOpacity(0.7)
                                    : AppColors.subText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Provider Card
              GestureDetector(
                onTap: () => setState(() => _selectedRole = 'provider'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _selectedRole == 'provider'
                        ? AppColors.homePrimary
                        : AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.homePrimary, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: _selectedRole == 'provider'
                            ? const Icon(Icons.engineering, color: AppColors.primaryWhite, size: 48)
                            : Image.asset(
                                'assets/icons/Izu_provider_icon.png',
                                fit: BoxFit.contain,
                                color: AppColors.homePrimary,
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              IzuAuthTexts.continueAsProvider,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _selectedRole == 'provider'
                                    ? AppColors.primaryWhite
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              IzuAuthTexts.earnMoneyDesc,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: _selectedRole == 'provider'
                                    ? AppColors.primaryWhite.withOpacity(0.7)
                                    : AppColors.subText,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    final authStorageService = Get.find<AuthStorageService>();
                    await authStorageService.storeSelectedRole(_selectedRole);
                    Get.to(() => CreateAccountScreen(selectedRole: _selectedRole));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.authButtonBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        IzuAuthTexts.continueBtn,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: AppColors.primaryWhite, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
