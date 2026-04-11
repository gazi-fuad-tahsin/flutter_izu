import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/constants/texts.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header_logo.dart';
import 'set_new_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.email});
  
  final String email;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  String _currentOtp = '';

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onOtpCompleted(String otp) {
    setState(() {
      _currentOtp = otp;
    });
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
                appTexts.authEnterOtpTitle.tr, // 'Enter OTP'
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),

              // 5-box OTP field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return SizedBox(
                    width: 50,
                    height: 56,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.authBorderGrey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.authBorderGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.authButtonBlue, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 4) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isNotEmpty && index == 4) {
                          _focusNodes[index].unfocus();
                          _onOtpCompleted(_controllers.map((c) => c.text).join());
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Setup resend text
              Text(
                appTexts.authResendCodeIn.tr, // 'Resend code in 45s'
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              // Resend action
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appTexts.authDidntReceiveOtp.tr, // 'Didn\'t Receive OTP?'
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement resend OTP logic
                    },
                    child: Text(
                      appTexts.authResendOtp.tr, // 'RESEND OTP'
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E5F48), // Dark green looking color from screenshot
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Verify Button
              AuthButton(
                text: appTexts.authVerifyNow.tr, // 'Verify Now'
                onPressed: () {
                  // TODO: implement verification logic
                  Get.to(() => SetNewPasswordScreen(
                    email: widget.email,
                    otp: _currentOtp,
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
