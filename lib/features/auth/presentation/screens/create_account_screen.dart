import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/constants/texts.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header_logo.dart';
import '../widgets/auth_text_field.dart';
import 'LogIn_screen.dart';
import 'selfie_verification_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  final String selectedRole;
  const CreateAccountScreen({super.key, required this.selectedRole});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Logo
              const AuthHeaderLogo(),
              const SizedBox(height: 10),

              // Title
              Text(
                appTexts.authLetsGetStarted.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appTexts.authCreateAccount.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // Form fields
              AuthTextField(
                label: appTexts.authUserName.tr,
                hint: appTexts.authEnterFirstName.tr,
                prefixIcon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              
              AuthTextField(
                label: "Your Email", // appTexts.emailAddress.tr or similar
                hint: appTexts.authEnterEmail.tr,
                prefixIcon: Icons.mail_outline,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              AuthTextField(
                label: appTexts.authPhoneNumber.tr,
                hint: appTexts.authEnterPhone.tr,
                prefixIcon: Icons.phone_outlined,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              AuthTextField(
                label: appTexts.authPassword.tr,
                hint: appTexts.authEnterPassword.tr,
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 20),

              AuthTextField(
                label: appTexts.authConfirmPassword.tr,
                hint: appTexts.authEnterConfirmPassword.tr,
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _confirmPassController,
              ),
              const SizedBox(height: 32),

              // Sign Up Button
              AuthButton(
                text: appTexts.authSignUp.tr,
                onPressed: () {
                  // TODO: Implement signup logic
                  Get.to(() => const SelfieVerificationScreen());
                },
              ),
              const SizedBox(height: 40),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appTexts.authAlreadyHaveAccount.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const LoginRoleScreen());
                    },
                    child: Text(
                      appTexts.authSignInHere.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.authTextOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
