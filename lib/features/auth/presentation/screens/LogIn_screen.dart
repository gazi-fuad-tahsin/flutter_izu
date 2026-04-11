import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/constants/texts.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header_logo.dart';
import '../widgets/auth_text_field.dart';
import 'create_account_screen.dart';
import 'forgot_email_screen.dart';
import 'role_selection_screen.dart';
import '../../../home/presentation/screens/user_home_screen.dart';

class LoginRoleScreen extends StatefulWidget {
  const LoginRoleScreen({super.key});

  @override
  State<LoginRoleScreen> createState() => _LoginRoleScreenState();
}

class _LoginRoleScreenState extends State<LoginRoleScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              const SizedBox(height: 40),
              // Logo
              const AuthHeaderLogo(),
              const SizedBox(height: 20),

              // Form fields
              AuthTextField(
                label: appTexts.authUserEmail.tr,
                hint: appTexts.authEnterEmail.tr,
                prefixIcon: Icons.mail_outline,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              
              AuthTextField(
                label: appTexts.authPassword.tr,
                hint: appTexts.authEnterPassword.tr,
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 16),

              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => const ForgotEmailScreen());
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    appTexts.authForgotPassword.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.authTextOrange,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Sign In Button
              AuthButton(
                text: appTexts.authSignIn.tr,
                onPressed: () {
                  // TODO: Implement login logic
                  Get.offAll(() => const UserHomeScreen());
                },
              ),
              const SizedBox(height: 40),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appTexts.authDontHaveAccount.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const RoleSelectionScreen());
                    },
                    child: Text(
                      appTexts.authSignUpHere.tr,
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
