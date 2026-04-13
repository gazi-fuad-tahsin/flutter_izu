import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/constants/app_images.dart';
import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../controller/auth_controller.dart';

/// OTP screen that follows the old UI design (dark background style).
/// Used in the forgot password flow from ForgotEmailScreen.
class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key, required this.email});
  final String email;

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _submitOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      Get.snackbar(
        IzuAuthTexts.loginError,
        'Please enter complete OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.logoutRed,
        colorText: AppColors.primaryWhite,
      );
      return;
    }

    // Call verify OTP from controller
    await _authController.verifyOTP(widget.email, otp, isRegistrationFlow: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // App Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  AppImages.appLogo,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 40),

              // Title
              const Text(
                'OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.containerBG,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'We have sent the verification code to your\nemail address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 60),

              // OTP Input Boxes (6 boxes)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    const spacing = 6.0;
                    const totalSpacing = spacing * 5;
                    final boxSize = ((availableWidth - totalSpacing) / 6).clamp(45.0, 65.0);
                    final fontSize = boxSize > 45 ? 25.0 : 20.0;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return Container(
                          width: boxSize,
                          height: boxSize,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _otpControllers[index].text.isNotEmpty
                                  ? AppColors.textBlack
                                  : AppColors.pinFieldColor,
                              width: 2,
                            ),
                          ),
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryWhite,
                              height: 1.0,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.symmetric(
                                vertical: boxSize / 2 - fontSize / 2,
                                horizontal: 0,
                              ),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              setState(() {});
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Resend Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't get the code? ",
                    style: TextStyle(fontSize: 14, color: AppColors.subText),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Resend it',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.containerBG,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Continue Button with loading state
              GetBuilder<AuthController>(
                builder: (controller) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : _submitOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isLoading.value
                          ? AppColors.containerBG.withOpacity(0.6)
                          : AppColors.containerBG,
                        disabledBackgroundColor: AppColors.containerBG.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
                          'Verify Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Backward-compat alias (some screens may still use OtpVerificationScreen) ───
// ignore: non_constant_identifier_names
Widget OtpVerificationScreenAlias({required String email}) =>
    OtpVerifyScreen(email: email);
