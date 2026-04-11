import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/constants/texts.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header_logo.dart';
import '../widgets/auth_text_field.dart';
import 'otp_verification_screen.dart';

class ForgotEmailScreen extends StatefulWidget {
  const ForgotEmailScreen({super.key});

  @override
  State<ForgotEmailScreen> createState() => _ForgotEmailScreenState();
}

class _ForgotEmailScreenState extends State<ForgotEmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
                appTexts.authResetPasswordTitle.tr, // 'Reset password'
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appTexts.authEnterEmailOtp.tr, // 'Enter your email to receive the OTP'
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
                label: "Your Email", // appTexts.emailAddress.tr
                hint: appTexts.authEnterEmail.tr,
                prefixIcon: Icons.mail_outline,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),

              // Send OTP Button
              AuthButton(
                text: appTexts.authSendOtp.tr,
                onPressed: () {
                  // TODO: Implement forgot password logic
                  Get.to(() => OtpVerificationScreen(
                    email: _emailController.text,
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
