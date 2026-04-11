import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/constants/texts.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header_logo.dart';
import '../widgets/auth_text_field.dart';
import 'LogIn_screen.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Logo
              const AuthHeaderLogo(),
              const SizedBox(height: 20),

              // Title
              Text(
                appTexts.authResetNewPassword.tr, // 'Reset New password'
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appTexts.authEnterNewAndConfirm.tr, // 'Enter your new password and confirm password'
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Form fields
              AuthTextField(
                label: appTexts.authNewPassword.tr, // 'New Password'
                hint: appTexts.authEnterPassword.tr,
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 24),

              AuthTextField(
                label: appTexts.authConfirmPassword.tr, // 'Confirm Password'
                hint: appTexts.authEnterConfirmPassword.tr,
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _confirmPassController,
              ),
              const SizedBox(height: 40),

              // Continue Button
              AuthButton(
                text: appTexts.authContinue.tr, // 'Continue'
                onPressed: () {
                  // TODO: implement set new password logic
                  Get.offAll(() => const LoginRoleScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
