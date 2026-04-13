import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_header_logo.dart';
import '../widgets/auth_text_field.dart';
import 'forgot_email_screen.dart';
import 'role_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_emailController.text.trim().isEmpty) {
      Get.snackbar(
        IzuAuthTexts.loginError,
        IzuAuthTexts.enterEmailError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.logoutRed,
        colorText: AppColors.primaryWhite,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (_passwordController.text.isEmpty) {
      Get.snackbar(
        IzuAuthTexts.loginError,
        IzuAuthTexts.enterPasswordError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.logoutRed,
        colorText: AppColors.primaryWhite,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    _authController.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
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
                label: IzuAuthTexts.userEmailLabel,
                hint: IzuAuthTexts.userEmailHint,
                prefixIcon: Icons.mail_outline,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              AuthTextField(
                label: IzuAuthTexts.passwordLabel,
                hint: IzuAuthTexts.passwordHint,
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
                    IzuAuthTexts.forgotPassword,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.authTextOrange,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Sign In Button with Loading State
              Obx(() {
                final isLoading = _authController.isLoading.value;
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.authButtonBlue,
                      disabledBackgroundColor: AppColors.authButtonBlue.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryWhite),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            IzuAuthTexts.signIn,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryWhite,
                            ),
                          ),
                  ),
                );
              }),
              const SizedBox(height: 40),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    IzuAuthTexts.dontHaveAccount,
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
                      IzuAuthTexts.signUpHere,
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
